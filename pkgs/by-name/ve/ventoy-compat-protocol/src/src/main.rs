#![feature(ascii_char, ascii_char_variants)]

use anyhow::{bail, Context, Result};
use clap::{Args, Parser, Subcommand};
use env_logger;
use log::debug;
use std::ascii::Char;
use std::env;
use std::fmt;
use std::fs;
use std::fs::File;
use std::io::prelude::*;
use std::io::SeekFrom;
use std::io::{stdout, Write};
use std::os::unix::ffi::OsStrExt;
use std::os::unix::fs::symlink;
use std::path::{Component, Path, PathBuf};
use uuid::{uuid, Uuid};

const VENTOY_UUID: Uuid = uuid!("20207777772e76656e746f792e6e6574");

#[derive(Debug)]
enum FileSystem {
    ExFat,
    NTFS,
    Ext,
    XFS,
    UDF,
    FAT,
    Other,
}

impl fmt::Display for FileSystem {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        let fstype = match self {
            FileSystem::ExFat => "exfat",
            FileSystem::NTFS => "ntfs",
            FileSystem::Ext => "ext4",
            FileSystem::XFS => "xfs",
            FileSystem::UDF => "udf",
            FileSystem::FAT => "vfat",
            FileSystem::Other => "not-a-file-system",
        };
        write!(f, "{}", fstype)
    }
}

#[derive(Debug)]
struct VentoyOSParam {
    disk_guid: Uuid,
    _disk_size: u64,
    partition_num: u16,
    partition_fs: FileSystem,
    iso_file_path: PathBuf,
    _iso_file_size: u64,
    disk_sig: [u8; 4],
}

fn search_for_sig(bytes: &[u8]) -> Result<[u8; 512]> {
    if bytes.len() < 512 {
        bail!("Slice too small");
    }
    for i in 0..=bytes.len() - 512 {
        let sig_candidate = uuid::Builder::from_slice(&bytes[i..i + 16])?.into_uuid();
        if sig_candidate == VENTOY_UUID {
            return Ok(bytes[i..i + 512].try_into()?);
        }
    }
    bail!("Could not find signature")
}

fn parse(bytes: &[u8; 512]) -> Result<VentoyOSParam> {
    {
        let ventoy_sig: Uuid = uuid::Builder::from_slice(&bytes[0..16])?.into_uuid();
        if ventoy_sig != VENTOY_UUID {
            bail!("Signature does not match");
        }
    }
    {
        let mut cksum: u8 = 0;
        for i in bytes {
            cksum = cksum.wrapping_add(*i);
        }
        if cksum != 0 {
            bail!("Checksum was no good");
        }
    }

    Ok(VentoyOSParam {
        disk_guid: uuid::Builder::from_slice(&bytes[17..33])?.into_uuid(),
        _disk_size: u64::from_le_bytes(bytes[33..41].try_into()?),
        partition_num: u16::from_le_bytes(bytes[41..43].try_into()?),
        partition_fs: match u16::from_le_bytes(bytes[43..45].try_into()?) {
            0 => FileSystem::ExFat,
            1 => FileSystem::NTFS,
            2 => FileSystem::Ext,
            3 => FileSystem::XFS,
            4 => FileSystem::UDF,
            5 => FileSystem::FAT,
            _ => FileSystem::Other,
        },
        iso_file_path: {
            let str_buf = &bytes[45..429];
            let nul_pos = str_buf
                .iter()
                .position(|&b| b == 0)
                .context("ISO file path was not null terminated")?;
            PathBuf::from(
                String::from_utf8(str_buf[..nul_pos].to_vec())
                    .context("ISO file path was not valid UTF-8")?,
            )
        },
        _iso_file_size: u64::from_le_bytes(bytes[429..437].try_into()?),
        disk_sig: bytes[481..485].try_into()?,
    })
}

fn read_table_from_file<P: AsRef<Path>>(path: P) -> Result<VentoyOSParam> {
    debug!("Using raw file: {:?}", path.as_ref());
    let mut buf = [0; 512];
    File::open(path)?.read_exact(&mut buf)?;
    let table = parse(&buf)?;
    debug!("Table: {table:?}");
    Ok(table)
}

fn read_table() -> Result<VentoyOSParam> {
    let acpi_path = PathBuf::from("/sys/firmware/acpi/tables/VTOY");
    let efi_path = PathBuf::from(
        "/sys/firmware/efi/efivars/VentoyOsParam-77772020-2e77-6576-6e74-6f792e6e6574",
    );

    if let Ok(raw_path) = env::var("VENTOY_TABLE_FILE") {
        return read_table_from_file(Path::new(&raw_path));
    }

    let contents = if acpi_path.is_file() {
        debug!("Searching {acpi_path:?}");
        fs::read(acpi_path)?
    } else if efi_path.is_file() {
        debug!("Searching {efi_path:?}");
        fs::read(efi_path)?
    } else {
        debug!("Searching /dev/mem");
        let mut f = File::open("/dev/mem")?;
        f.seek(SeekFrom::Start(0x80000))?;
        let mut buf = [0; 0x20000];
        f.read_exact(&mut buf)?;
        buf.to_vec()
    };
    let table = parse(&search_for_sig(&contents)?)?;
    debug!("Table: {table:?}");
    Ok(table)
}

#[derive(Parser, Debug)]
#[command(about, multicall = true)]
enum VentoyCompatProtocolMulticall {
    VentoyCompatProtocol {
        /// File with raw dump of the Ventoy table
        #[arg(long, value_name = "FILE")]
        raw: Option<PathBuf>,

        #[command(subcommand)]
        command: VentoyCompatProtocolCommands,
    },
    VentoyCompatProtocolGenerator {
        normal_dir: PathBuf,
        early_dir: Option<PathBuf>,
        late_dir: Option<PathBuf>,
    },
}

#[derive(Args, Debug)]
struct VentoyCompatProtocol {
    /// File with raw dump of the Ventoy table
    #[arg(long, value_name = "FILE")]
    raw: Option<PathBuf>,

    #[command(subcommand)]
    command: VentoyCompatProtocolCommands,
}

#[derive(Subcommand, Debug)]
enum VentoyCompatProtocolCommands {
    PrintISOPath,
    PrintFileSystem,
    Udev { device: PathBuf },
    UdevPartMatch { partnum1: u64, partnum2: u64 },
    DetectHook,
}

fn print_iso_path(table: VentoyOSParam) -> Result<()> {
    stdout()
        .write_all(table.iso_file_path.into_os_string().as_bytes())
        .context("Failed to write output")?;
    Ok(())
}

fn print_file_system(table: VentoyOSParam) -> Result<()> {
    match table.partition_fs {
        FileSystem::Other => bail!("File system type not recognized"),
        _ => print!("{}", table.partition_fs),
    }
    Ok(())
}

fn print_udev_props(table: VentoyOSParam, device: PathBuf) -> Result<()> {
    let mut f = File::open(device)?;
    f.seek(SeekFrom::Start(0x180))?;
    let mut guid_bytes = [0; 16];
    f.read_exact(&mut guid_bytes)?;
    f.seek(SeekFrom::Start(0x1b8))?;
    let mut sig_bytes = [0; 4];
    f.read_exact(&mut sig_bytes)?;

    let guid = uuid::Builder::from_slice(&guid_bytes)?.into_uuid();

    debug!("{guid} x {sig_bytes:?}");
    if guid == table.disk_guid && sig_bytes == table.disk_sig {
        println!("ID_VENTOY=1");
        println!("ID_VENTOY_PARTNUM={}", table.partition_num);
    }

    Ok(())
}

fn detect_hook() -> bool {
    Path::new("/etc/initrd-release").exists() && Path::new("/ventoy").is_dir()
}

fn bail_on_hook() -> Result<()> {
    if detect_hook() {
        bail!(
            "Detected Ventoy hook.

This ISO implements the \"Ventoy Compatible\" protocol. However,
Ventoy appears to have installed its initramfs hook. These boot
methods are incompatible.

Please fix your Ventoy configuration.

See also: https://www.ventoy.net/en/compatible.html
"
        );
    }
    Ok(())
}

fn ventoy_compat_protocol(
    raw: Option<PathBuf>,
    command: VentoyCompatProtocolCommands,
) -> Result<()> {
    let table = || {
        raw.map(read_table_from_file)
            .unwrap_or_else(|| read_table())
    };
    match command {
        VentoyCompatProtocolCommands::PrintISOPath => print_iso_path(table()?),
        VentoyCompatProtocolCommands::PrintFileSystem => print_file_system(table()?),
        VentoyCompatProtocolCommands::Udev { device } => print_udev_props(table()?, device),
        VentoyCompatProtocolCommands::UdevPartMatch { partnum1, partnum2 } => {
            if partnum1 == partnum2 {
                println!("ID_VENTOY_PART=1");
            }
            Ok(())
        }
        VentoyCompatProtocolCommands::DetectHook => bail_on_hook(),
    }
}

fn sd_escape_path<P: AsRef<Path>>(path: &P) -> Result<String> {
    if path.as_ref() == Path::new("/") {
        return Ok("-".to_string());
    }

    let mut all_escaped: Vec<String> = vec![];
    for comp in path.as_ref().components() {
        match comp {
            Component::Prefix(_) => bail!("No windows"),
            Component::RootDir => {} // Leading slashes are ignored for paths
            Component::CurDir => {}  // Redundant
            Component::ParentDir => bail!("Can't handle '..'"),
            Component::Normal(comp_str) => {
                let mut comp_escaped = "".to_string();
                for b in comp_str.as_bytes() {
                    if let Some(x) = Char::from_u8(*b)
                        && ((Char::CapitalA..Char::CapitalZ).contains(&x)
                            || (Char::SmallA..Char::SmallZ).contains(&x)
                            || (Char::Digit0..Char::Digit9).contains(&x)
                            || x == Char::LowLine
                            || x == Char::FullStop
                            || x == Char::Colon)
                    {
                        comp_escaped.push(x.to_char())
                    } else {
                        comp_escaped.push_str(&format!("\\x{:02x}", b));
                    }
                }
                all_escaped.push(comp_escaped);
            }
        }
    }
    Ok(all_escaped.join("-"))
}

fn generate_mount(table: &VentoyOSParam, mut dir: PathBuf, mut wants_dir: PathBuf) -> Result<()> {
    let unit_name = "run-ventoy.mount";
    match table.partition_fs {
        FileSystem::Other => {}
        _ => {
            dir.push(&format!("{unit_name}.d"));
            fs::create_dir_all(&dir)?;
            dir.push("ventoy-fs-type.conf");
            fs::write(
                dir,
                format!(
                    "\
[Mount]
Type={}
",
                    table.partition_fs
                ),
            )?;
        }
    }
    wants_dir.push(&unit_name);
    symlink(&PathBuf::from(format!("../{}", unit_name)), &wants_dir)
        .context(format!("Failed to create dependency on {}", unit_name))
}

fn generate_losetup(table: &VentoyOSParam, mut wants_dir: PathBuf) -> Result<()> {
    let unit_name = format!(
        "ventoy-losetup@{}.service",
        sd_escape_path(&table.iso_file_path)?
    );
    wants_dir.push(&unit_name);
    symlink(&PathBuf::from(format!("../{}", unit_name)), &wants_dir)
        .context(format!("Failed to create dependency on {}", unit_name))
}

fn ventoy_compat_protocol_generator(dir: PathBuf) -> Result<()> {
    if detect_hook() {
        let mut detect_path = dir.clone();
        detect_path.push("sysroot.mount.requires");
        fs::create_dir_all(&detect_path).context("Failed to create sysroot.mount.requires")?;
        detect_path.push("ventoy-detect-hook.service");
        return symlink(
            &PathBuf::from("../ventoy-detect-hook.service"),
            &detect_path,
        )
        .context("Failed to create dependency on ventoy-detect-hook.service");
    }

    let table = read_table();
    match table {
        Err(_) => Ok(()),
        Ok(table) => {
            let mut wants_dir = dir.clone();
            wants_dir.push("initrd.target.wants");
            fs::create_dir_all(&wants_dir).context("Failed to create initrd.target.wants")?;
            generate_mount(&table, dir, wants_dir.clone())?;
            generate_losetup(&table, wants_dir)
        }
    }
}

fn main() -> Result<()> {
    env_logger::init();
    let myargs = VentoyCompatProtocolMulticall::parse();

    match myargs {
        VentoyCompatProtocolMulticall::VentoyCompatProtocol { raw, command } => {
            ventoy_compat_protocol(raw, command)
        }
        VentoyCompatProtocolMulticall::VentoyCompatProtocolGenerator {
            normal_dir,
            early_dir: _,
            late_dir: _,
        } => ventoy_compat_protocol_generator(normal_dir),
    }
}
