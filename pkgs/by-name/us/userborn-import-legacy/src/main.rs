//! One-shot migration from `update-users-groups.pl` state in `/var/lib/nixos`
//! to the on-disk databases that userborn treats as authoritative.
//!
//! userborn never deletes entries from /etc/{passwd,group,shadow}; it only
//! locks accounts and drains group members. That makes /etc/passwd itself
//! the uid-map. To migrate safely we therefore make /etc/passwd a superset
//! of what /var/lib/nixos/uid-map remembers: every name that ever had a
//! dynamically allocated id gets a locked stub entry, so the id can neither
//! be reassigned to a different name nor lost if the name is later re-added.
//!
//! Intended to run exactly once, gated by `ConditionPathExists` in the unit.
//! It is deliberately small and will be removed once the perl implementation
//! is gone.

use std::collections::{BTreeMap, HashMap, HashSet};
use std::fs::{self, File, OpenOptions};
use std::io::{self, Read, Seek, SeekFrom, Write};
use std::os::unix::fs::PermissionsExt;
use std::path::{Path, PathBuf};
use std::process::ExitCode;

use anyhow::{Context, Result, bail};

const LEGACY: &str = "/var/lib/nixos";
const USERBORN_STATE: &str = "/var/lib/userborn";
const SENTINEL_NAME: &str = ".legacy-imported";
const PREVIOUS_NAME: &str = "previous-userborn.json";

fn main() -> ExitCode {
    match run() {
        Ok(()) => ExitCode::SUCCESS,
        Err(e) => {
            // Kernel printk numeric prefix so journald picks up the level.
            eprintln!("<3>userborn-import-legacy: {e:#}");
            ExitCode::FAILURE
        }
    }
}

#[derive(Debug)]
struct Args {
    directory: PathBuf,
    /// Primary group for stub passwd entries when the legacy gid-map has no
    /// record for the user's name. Passed in from `config.ids.gids.nogroup`;
    /// the stub is locked and has no shell, so any valid gid would do.
    nogroup_gid: u32,
}

impl Args {
    const USAGE: &str = "usage: userborn-import-legacy [--nogroup-gid GID] [DIRECTORY]";

    fn parse() -> Result<Self> {
        let mut directory: Option<PathBuf> = None;
        let mut nogroup_gid = 65534u32;
        let mut iter = std::env::args().skip(1);
        while let Some(arg) = iter.next() {
            match arg.as_str() {
                "--nogroup-gid" => {
                    nogroup_gid = iter
                        .next()
                        .context("--nogroup-gid requires a value")?
                        .parse()
                        .context("--nogroup-gid must be an integer")?;
                }
                "--help" | "-h" => {
                    println!("{}", Self::USAGE);
                    std::process::exit(0);
                }
                opt if opt.starts_with('-') => {
                    bail!("unknown option {opt:?}\n{}", Self::USAGE);
                }
                _ if directory.is_some() => {
                    bail!("unexpected extra argument {arg:?}\n{}", Self::USAGE);
                }
                _ => directory = Some(PathBuf::from(arg)),
            }
        }
        Ok(Self {
            directory: directory.unwrap_or_else(|| PathBuf::from("/etc")),
            nogroup_gid,
        })
    }
}

fn run() -> Result<()> {
    let args = Args::parse()?;

    fs::create_dir_all(&args.directory)
        .with_context(|| format!("creating {}", args.directory.display()))?;
    fs::create_dir_all(USERBORN_STATE).with_context(|| format!("creating {USERBORN_STATE}"))?;

    import_ids(&args)?;
    synthesise_previous_config()?;

    File::create(Path::new(USERBORN_STATE).join(SENTINEL_NAME))
        .context("creating sentinel file")?;
    Ok(())
}

fn info(msg: &str) {
    eprintln!("<6>userborn-import-legacy: {msg}");
}

fn warn(msg: &str) {
    eprintln!("<4>userborn-import-legacy: {msg}");
}

/// Load `/var/lib/nixos/{uid,gid}-map`: `{"name": id, ...}`.
fn load_id_map(path: &Path) -> Result<BTreeMap<String, u32>> {
    match fs::read(path) {
        Ok(bytes) => {
            serde_json::from_slice(&bytes).with_context(|| format!("parsing {}", path.display()))
        }
        Err(e) if e.kind() == io::ErrorKind::NotFound => Ok(BTreeMap::new()),
        Err(e) => Err(e).with_context(|| format!("reading {}", path.display())),
    }
}

/// Return `(names, id->name)` from a passwd/group style file.
fn load_colon_db(path: &Path) -> Result<(HashSet<String>, HashMap<u32, String>)> {
    let mut names = HashSet::new();
    let mut by_id = HashMap::new();
    let text = match fs::read_to_string(path) {
        Ok(t) => t,
        Err(e) if e.kind() == io::ErrorKind::NotFound => return Ok((names, by_id)),
        Err(e) => return Err(e).with_context(|| format!("reading {}", path.display())),
    };
    for line in text.lines() {
        let mut fields = line.splitn(4, ':');
        let Some(name) = fields.next().filter(|n| !n.is_empty()) else {
            // passwd(5)/group(5) do not allow empty names; tolerate blank
            // lines in hand-edited files quietly, complain about anything
            // else so corruption is visible.
            if !line.is_empty() {
                warn(&format!(
                    "{}: ignoring line without a name: {line:?}",
                    path.display()
                ));
            }
            continue;
        };
        let _passwd = fields.next();
        let Some(id) = fields.next().and_then(|s| s.parse::<u32>().ok()) else {
            warn(&format!(
                "{}: ignoring entry {name:?} without a numeric id",
                path.display()
            ));
            continue;
        };
        names.insert(name.to_owned());
        by_id.insert(id, name.to_owned());
    }
    Ok((names, by_id))
}

/// Append `lines` (without trailing newlines) to `path`, one per line.
///
/// Guards against an existing file that does not end in a newline (e.g. a
/// hand-edited /etc/passwd) so the first appended record is not glued onto
/// the last existing one. The file is assumed to already exist with the
/// right mode (see `touch` in `import_ids`).
fn append_lines(path: &Path, lines: &[String]) -> Result<()> {
    if lines.is_empty() {
        return Ok(());
    }
    let mut f = OpenOptions::new()
        .append(true)
        .read(true)
        .open(path)
        .with_context(|| format!("opening {}", path.display()))?;
    let len = f.metadata()?.len();
    if len > 0 {
        f.seek(SeekFrom::Start(len - 1))?;
        let mut last = [0u8; 1];
        f.read_exact(&mut last)?;
        if last[0] != b'\n' {
            f.write_all(b"\n")?;
        }
    }
    for line in lines {
        f.write_all(line.as_bytes())?;
        f.write_all(b"\n")?;
    }
    Ok(())
}

fn touch(path: &Path, mode: u32) -> Result<()> {
    if path.exists() {
        return Ok(());
    }
    File::create(path).with_context(|| format!("creating {}", path.display()))?;
    fs::set_permissions(path, fs::Permissions::from_mode(mode))
        .with_context(|| format!("chmod {}", path.display()))?;
    Ok(())
}

fn import_ids(args: &Args) -> Result<()> {
    let passwd = args.directory.join("passwd");
    let group = args.directory.join("group");
    let shadow = args.directory.join("shadow");

    // Ensure all three exist with the right mode before append_lines()
    // opens them (it does not create), and so shadow never has a window
    // at the default 0644 while we write locked-password stubs into it.
    touch(&passwd, 0o644)?;
    touch(&group, 0o644)?;
    touch(&shadow, 0o640)?;

    let (mut user_names, mut user_ids) = load_colon_db(&passwd)?;
    let (mut group_names, mut group_ids) = load_colon_db(&group)?;

    let legacy = Path::new(LEGACY);
    let gid_map = load_id_map(&legacy.join("gid-map"))?;
    let uid_map = load_id_map(&legacy.join("uid-map"))?;

    let mut new_group = Vec::new();
    for (name, &gid) in &gid_map {
        if group_names.contains(name) {
            continue;
        }
        if let Some(owner) = group_ids.get(&gid) {
            warn(&format!(
                "gid {gid} from gid-map for {name:?} is already used by {owner:?}; skipping"
            ));
            continue;
        }
        info(&format!("reserving gid {gid} for removed group {name:?}"));
        new_group.push(format!("{name}:x:{gid}:"));
        group_names.insert(name.clone());
        group_ids.insert(gid, name.clone());
    }
    append_lines(&group, &new_group)?;

    let mut new_passwd = Vec::new();
    let mut new_shadow = Vec::new();
    for (name, &uid) in &uid_map {
        if user_names.contains(name) {
            continue;
        }
        if let Some(owner) = user_ids.get(&uid) {
            warn(&format!(
                "uid {uid} from uid-map for {name:?} is already used by {owner:?}; skipping"
            ));
            continue;
        }
        // Prefer the gid recorded for the same name, falling back to nogroup.
        let gid = gid_map.get(name).copied().unwrap_or(args.nogroup_gid);
        info(&format!("reserving uid {uid} for removed user {name:?}"));
        new_passwd.push(format!(
            "{name}:x:{uid}:{gid}::/var/empty:/run/current-system/sw/bin/nologin"
        ));
        new_shadow.push(format!("{name}:!*:1::::::"));
        user_names.insert(name.clone());
        user_ids.insert(uid, name.clone());
    }
    append_lines(&passwd, &new_passwd)?;
    append_lines(&shadow, &new_shadow)?;

    Ok(())
}

/// Populate `previous-userborn.json` from `declarative-{users,groups}`.
///
/// Under `mutableUsers`, userborn distinguishes declaratively-managed
/// entries from imperatively created ones (`useradd` etc.) by comparing
/// the current config against the *previous* one
/// (`USERBORN_PREVIOUS_CONFIG`): an entry that was in the previous config
/// but is absent from the current one gets locked/drained, whereas an
/// entry in neither config is left untouched.
///
/// On the first run after switching from perl there is no previous
/// userborn config, so without this every formerly-declarative user that
/// was dropped in the same switch would be treated as imperative and left
/// enabled. The perl script records the declarative set in
/// `/var/lib/nixos/declarative-{users,groups}`; translate that into the
/// minimal JSON shape userborn expects (`{"users": [{"name": ...}], ...}`)
/// so its first run applies the same lock/drain semantics the perl script
/// would have.
fn synthesise_previous_config() -> Result<()> {
    let previous = Path::new(USERBORN_STATE).join(PREVIOUS_NAME);
    if previous.exists() {
        // Should be unreachable: the unit is gated on the .legacy-imported
        // sentinel and userborn's ExecStartPost is what writes this file.
        // Keep the guard regardless; clobbering a real previous config
        // would make userborn forget every declarative entry.
        warn(&format!(
            "{} already exists; not overwriting",
            previous.display()
        ));
        return Ok(());
    }

    let names = |path: &Path| -> Result<Vec<serde_json::Value>> {
        let text = match fs::read_to_string(path) {
            Ok(t) => t,
            Err(e) if e.kind() == io::ErrorKind::NotFound => return Ok(Vec::new()),
            Err(e) => return Err(e).with_context(|| format!("reading {}", path.display())),
        };
        Ok(text
            .split_whitespace()
            .map(|n| serde_json::json!({ "name": n }))
            .collect())
    };

    let legacy = Path::new(LEGACY);
    let doc = serde_json::json!({
        "users": names(&legacy.join("declarative-users"))?,
        "groups": names(&legacy.join("declarative-groups"))?,
    });
    fs::write(&previous, serde_json::to_vec(&doc)?)
        .with_context(|| format!("writing {}", previous.display()))?;
    info(&format!(
        "synthesised {} from declarative-users/groups",
        previous.display()
    ));
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn colon_db() {
        let dir = tempdir();
        let p = dir.join("passwd");
        fs::write(
            &p,
            "root:x:0:0::/root:/bin/sh\n\
             nobody:x:65534:65534::/var/empty:/bin/nologin\n\
             :::\n\
             bogus:x:notanumber:0::\n",
        )
        .unwrap();
        let (names, ids) = load_colon_db(&p).unwrap();
        assert!(names.contains("root"));
        assert!(names.contains("nobody"));
        assert_eq!(ids.get(&0), Some(&"root".to_owned()));
        assert!(!names.contains("bogus"));
    }

    #[test]
    fn append_adds_missing_newline() {
        let dir = tempdir();
        let p = dir.join("f");
        fs::write(&p, "a:x:1:").unwrap();
        append_lines(&p, &["b:x:2:".into()]).unwrap();
        assert_eq!(fs::read_to_string(&p).unwrap(), "a:x:1:\nb:x:2:\n");
    }

    #[test]
    fn id_map_missing_is_empty() {
        let dir = tempdir();
        assert!(load_id_map(&dir.join("nope")).unwrap().is_empty());
    }

    fn tempdir() -> PathBuf {
        let p = std::env::temp_dir().join(format!(
            "uil-test-{}-{}",
            std::process::id(),
            std::time::SystemTime::now()
                .duration_since(std::time::UNIX_EPOCH)
                .unwrap()
                .as_nanos()
        ));
        fs::create_dir_all(&p).unwrap();
        p
    }
}
