//! One-shot migration from `update-users-groups.pl` state in `/var/lib/nixos`
//! to the on-disk databases userborn treats as authoritative.
//!
//! userborn never deletes passwd/group entries, so /etc/passwd is its
//! uid-map. We make it a superset of /var/lib/nixos/uid-map by adding a
//! locked stub for every recorded name without a live entry, so the id is
//! neither reassigned nor lost if the name is later re-added.
//!
//! Runs once: the unit is skipped when `/var/lib/userborn` already exists,
//! which userborn creates on its first run. Will be removed once the perl
//! implementation is gone.

use std::collections::{BTreeMap, HashMap, HashSet};
use std::fs::{self, File, OpenOptions};
use std::io::{self, Write};
use std::os::unix::fs::{DirBuilderExt, OpenOptionsExt, PermissionsExt};
use std::path::{Path, PathBuf};
use std::process::ExitCode;

use anyhow::{Context, Result, bail};

const LEGACY: &str = "/var/lib/nixos";
const USERBORN_STATE: &str = "/var/lib/userborn";
const PREVIOUS_NAME: &str = "previous-userborn.json";

fn main() -> ExitCode {
    match run() {
        Ok(()) => ExitCode::SUCCESS,
        Err(e) => {
            // printk prefix for journald level.
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

    create_dir_recursive(&args.directory, 0o755)?;

    import_ids(&args)?;

    // Creating userborn's state directory marks the import as done. Only
    // create it after a successful import so failed runs are retried on
    // the next boot.
    create_dir_recursive(Path::new(USERBORN_STATE), 0o755)?;
    synthesise_previous_config()?;
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
            // Tolerate blank lines, warn on anything else.
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

/// Create `path` and any missing parents with the given mode.
///
/// Doesn't touch the permissions of directories that already exist.
fn create_dir_recursive(path: &Path, mode: u32) -> Result<()> {
    fs::DirBuilder::new()
        .recursive(true)
        .mode(mode)
        .create(path)
        .with_context(|| format!("creating {}", path.display()))
}

/// Atomically replace `path` with `content`: write a temporary file in the
/// same directory, fsync it, and rename it into place, so a crash cannot
/// leave a partially written database behind for the next boot.
fn atomic_write(path: &Path, content: &[u8], mode: u32) -> Result<()> {
    let dir = path.parent().context("path has no parent")?;
    let tmp = path.with_added_extension("tmp");
    let mut f = OpenOptions::new()
        .write(true)
        .create(true)
        .truncate(true)
        .mode(mode)
        .open(&tmp)
        .with_context(|| format!("creating {}", tmp.display()))?;
    // The mode passed to open is masked by the umask, so make sure we set
    // the actual permissions.
    f.set_permissions(fs::Permissions::from_mode(mode))
        .with_context(|| format!("chmod {}", tmp.display()))?;
    f.write_all(content)
        .with_context(|| format!("writing {}", tmp.display()))?;
    f.sync_all()?;
    drop(f);
    fs::rename(&tmp, path)
        .with_context(|| format!("renaming {} to {}", tmp.display(), path.display()))?;
    File::open(dir)?.sync_all()?;
    Ok(())
}

/// Append `lines` to `path` via a whole-file rewrite and an atomic rename,
/// inserting a newline first if the file lacks a trailing one. Assumes the
/// file already exists (see `touch`).
fn append_lines(path: &Path, lines: &[String]) -> Result<()> {
    if lines.is_empty() {
        return Ok(());
    }
    let mut content = fs::read(path).with_context(|| format!("reading {}", path.display()))?;
    if !content.is_empty() && !content.ends_with(b"\n") {
        content.push(b'\n');
    }
    for line in lines {
        content.extend_from_slice(line.as_bytes());
        content.push(b'\n');
    }
    // mode() returns the full st_mode; mask off the file type bits.
    let mode = fs::metadata(path)
        .with_context(|| format!("stat {}", path.display()))?
        .permissions()
        .mode()
        & 0o7777;
    atomic_write(path, &content, mode)
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

    touch(&passwd, 0o644)?;
    touch(&group, 0o644)?;
    touch(&shadow, 0o000)?;

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
/// Under `mutableUsers`, userborn diffs the current config against the
/// previous one to decide which entries to lock/drain vs leave alone.
/// Without a previous config on the first run, formerly-declarative users
/// dropped in the same switch would be treated as imperative and left
/// enabled. Translate the perl script's declarative-{users,groups} into
/// the minimal JSON userborn expects so its first run behaves correctly.
fn synthesise_previous_config() -> Result<()> {
    let previous = Path::new(USERBORN_STATE).join(PREVIOUS_NAME);
    if previous.exists() {
        // Unreachable via the unit's ConditionPathExists, but never clobber
        // a real previous config.
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
    atomic_write(&previous, &serde_json::to_vec(&doc)?, 0o644)
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
    fn append_keeps_mode() {
        let dir = tempdir();
        let p = dir.join("shadow");
        fs::write(&p, "a:!:1::::::\n").unwrap();
        fs::set_permissions(&p, fs::Permissions::from_mode(0o600)).unwrap();
        append_lines(&p, &["b:!*:1::::::".into()]).unwrap();
        assert_eq!(
            fs::metadata(&p).unwrap().permissions().mode() & 0o7777,
            0o600
        );
        assert_eq!(
            fs::read_to_string(&p).unwrap(),
            "a:!:1::::::\nb:!*:1::::::\n"
        );
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
