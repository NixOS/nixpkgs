use crate::{HELP_MSG, VERBOSE};
use anyhow::bail;
use serde_json::Value;

#[derive(Debug)]
pub struct Args {
    pub hashes_nix_path: String,
    pub channel: Option<String>,
    pub print: bool,
}

/// A bit impure function to parse the args. Might call exit
/// and block further exec.
pub fn parse_args() -> anyhow::Result<Args> {
    let mut args: Vec<String> = std::env::args().skip(1).collect();
    let mut i = 0;
    let mut ret = Args {
        channel: None,
        print: false,
        hashes_nix_path: String::new(),
    };
    while i < args.len() {
        match args[i].as_str() {
            "--thirdparty" => {
                let parsed: Value =
                    serde_json::from_str(include_str!("../THIRDPARTY.json")).unwrap();
                let l = parsed["third_party_libraries"].as_array().unwrap();
                for item in l {
                    println!("Package name: {}", item.get("package_name").unwrap());
                    let ll = item["licenses"].as_array().unwrap();
                    for subitem in ll {
                        println!("{}", subitem["license"].as_str().unwrap());
                        println!("{}", subitem["text"].as_str().unwrap());
                    }
                }
                std::process::exit(0);
            }
            "-h" | "--help" => {
                eprintln!("{HELP_MSG}");
                std::process::exit(0);
            }
            "-v" | "--verbose" => unsafe {
                VERBOSE = true;
            },
            "-c" | "--channel" => {
                if let Some(_) = args.get(i + 1) {
                    ret.channel = Some(std::mem::take(&mut args[i + 1]));
                    i += 2;
                    continue;
                } else {
                    bail!("Expected channel specifier (like stable or 3.0) but no next argument after {}", args[i]);
                }
            }
            "-p" | "--print" => {
                ret.print = true;
            }
            _ => {
                if ret.hashes_nix_path.is_empty() {
                    ret.hashes_nix_path = args[i].to_string();
                } else {
                    eprintln!("{HELP_MSG}");
                    bail!(
                        "engine-updater called with more than one file name. You can only use one, but you passed {} and then also {}",
                        ret.hashes_nix_path,
                        args[i]
                    );
                }
            }
        }

        i += 1;
    }

    if ret.hashes_nix_path.is_empty() {
        eprintln!("{}", HELP_MSG);
        bail!("You didn't pass a hashes.nix file path.");
    }

    return Ok(ret);
}
