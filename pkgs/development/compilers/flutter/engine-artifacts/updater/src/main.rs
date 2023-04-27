#![warn(clippy::pedantic)]

use anyhow::{bail, Context, Result};
/// This file is written in the crab lang because getting jq quotation
/// to work correctly in bash correctly was too much.
/// Also, this provides a speed improvement.
use futures::StreamExt;
use reqwest::Response;
use serde_json::{Map, Value};
use std::fs::OpenOptions;
use std::io::{Cursor, Write};
use std::process::Stdio;
use std::str::Utf8Error;
use tokio::process::Command;

const ENGINE_UPDATER_TMP_PATH: &str = "engine-updater-tmp";
const HELP_MSG: &str = r#"
engine-updater: Update flutter engine hashes.json
Usage: engine-updater <old hashes.nix file>
Arguments:
    -h, --help: display this help message
    --thirdparty: display thirdparty notices
"#;

/// A very impure[!] function to parse the args. Might call exit
/// and block further exec.
fn parse_args() -> String {
    let args: Vec<String> = std::env::args().collect();
    let args = &args[1..]; // skip the executable name
    let mut hashes_nix: Option<String> = None;
    for arg in args {
        match arg.as_str() {
            "--thirdparty" => {
                let tp = include_str!("../THIRDPARTY.json");
                let parsed: Value = serde_json::from_str(tp).unwrap();
                let l = parsed
                    .get("third_party_libraries")
                    .unwrap()
                    .as_array()
                    .unwrap();
                for item in l {
                    println!("Package name: {}", item.get("package_name").unwrap());
                    let ll = item.get("licenses").unwrap().as_array().unwrap();
                    for subitem in ll {
                        println!("{}", subitem.get("license").unwrap().as_str().unwrap());
                        println!("{}", subitem.get("text").unwrap().as_str().unwrap());
                    }
                }
                std::process::exit(0);
            }
            "-h" | "--help" => {
                println!("{HELP_MSG}");
                std::process::exit(0);
            }
            _ => {
                if hashes_nix.is_none() {
                    hashes_nix = Some(arg.to_string());
                } else {
                    println!(
    "engine-updater called with more than one file name. You can only use one, but you passed {} and then also {arg}", hashes_nix.unwrap());
                    println!("{HELP_MSG}");
                    std::process::exit(1);
                }
            }
        }
    }

    if hashes_nix.is_none() {
        println!("You didn't pass a hashes.nix file path.");
        println!("{}", HELP_MSG);
        std::process::exit(1);
    }

    return hashes_nix.unwrap().to_string();
}

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    // I don't want to add another dep for an arg parser this simple
    let hashes_nix = parse_args();
    println!("old hashes nix is at {hashes_nix}");
    let hashes_nix = hashes_nix.as_str();

    let client = reqwest::Client::new();
    tokio::fs::create_dir_all(ENGINE_UPDATER_TMP_PATH)
        .await
        .with_context(|| format!("creating directory at {ENGINE_UPDATER_TMP_PATH}"))?;

    let mut hashes_map_raw: Value = serde_json::from_str(
        get_hashes_json(hashes_nix)
            .context("Failed to get contents of the old hashes.nix")?
            .as_str(),
    )
    .context("Failed to parse the nix-to-json output to json")?;

    let hashes_map: &mut Map<String, Value> = hashes_map_raw
        .as_object_mut()
        .context("Failed to get hashes_map as an object, maybe the json isn't valid?")?;
    let new_engine_rev = get_engine_rev(&client)
        .await
        .context("Failed to get latest engine revision")?;
    let last_key = hashes_map
        .keys()
        .next()
        .context("Failed to get the last key of json, maybe json is empty?")?;
    // copy the last key for correct structure
    hashes_map.insert(new_engine_rev.clone(), hashes_map[last_key].clone());
    let n_eng_rev_key: &mut Map<String, Value> = hashes_map[&new_engine_rev]
        .as_object_mut()
        .with_context(|| "Failed to get key {new_engine_rev} from json")?;
    let mut all_fetchers = vec![];

    for (platform, value) in n_eng_rev_key {
        if let Some(val_map) = value.as_object_mut() {
            for (filename, _hash) in val_map {
                let a = Artifact {
                    engine_rev: new_engine_rev.clone(),
                    filename: Some(filename.to_string()),
                    platform: platform.to_string(),
                };
                all_fetchers.push(get_hash(a, &client));
            }
        } else {
            let a = Artifact {
                engine_rev: new_engine_rev.clone(),
                filename: None,
                platform: platform.to_string(),
            };

            all_fetchers.push(get_hash(a, &client));
        }
    }

    let fetched = futures::future::join_all(all_fetchers).await;
    println!("finished getting sources");

    for i in fetched {
        let (artifact, hash) = i?;
        let mut path = &mut hashes_map[&artifact.engine_rev][&artifact.platform];
        if let Some(x) = artifact.filename {
            path = &mut path[x];
        }
        *path = hash.into();
    }

    let final_json = serde_json::to_string_pretty(&hashes_map_raw)
        .context("Failed to print final json to string")?;
    dbg!(&final_json);
    let mut nix_contents_cmd = Command::new("nix-instantiate");
    let nix_contents_cmd = nix_contents_cmd
        .args([
            "--expr",
            "--eval",
            format!("builtins.fromJSON ''{final_json}''").as_str(),
        ])
        .stdout(Stdio::piped());
    let nix_contents_cmd = nix_contents_cmd
        .spawn()
        .with_context(|| format!("Failed to run {nix_contents_cmd:?}"))?;

    let nix_contents = std::str::from_utf8(
        &nix_contents_cmd
            .wait_with_output()
            .await
            .context("Failed to parse nix-instantiate output as utf8")?
            .stdout,
    )?
    .replace('{', "{\n")
    .replace('}', "\n}");
    let mut hashes2 = OpenOptions::new()
        .write(true)
        .create(true)
        .read(true)
        .truncate(true)
        .open(hashes_nix)
        .with_context(|| format!("Failed to open {hashes_nix}"))?;
    hashes2.write_all(nix_contents.as_bytes())?;

    // format the file because else it is a very ugly one-liner
    let _format_cmd = Command::new("nixpkgs-fmt")
        .arg(hashes_nix)
        .status()
        .await
        .context("Failed to format output with nixpkgs_fmt")?;

    tokio::fs::remove_dir_all(&ENGINE_UPDATER_TMP_PATH)
        .await
        .with_context(|| format!("Failed to delete temp dir at {ENGINE_UPDATER_TMP_PATH}"))?;
    Ok(())
}

async fn get_engine_rev(client: &reqwest::Client) -> Result<String> {
    const LATEST_URL: &str =
        "https://raw.githubusercontent.com/flutter/flutter/stable/bin/internal/engine.version";
    let res = client
        .get(LATEST_URL)
        .send()
        .await
        .with_context(|| format!("Failed to request {LATEST_URL}"))?
        .bytes()
        .await
        .with_context(|| format!("Failed to get body of {LATEST_URL}"))?;
    let parsed = std::str::from_utf8(&res)?;
    Ok(parsed.trim().replace('\n', ""))
}

#[derive(Debug)]
struct Artifact {
    engine_rev: String,
    platform: String,
    filename: Option<String>,
}

fn get_hashes_json(hashes_nix_path: &str) -> Result<String> {
    // `import hashes.nix` is not valid nix (hashes.nix here is not a path), so
    // we make it absolute, and then use `import /full/directory/hashes.nix`.
    // This has the added benefit of error-ing when the file doesn't exist.
    let parsed_path = std::fs::canonicalize(hashes_nix_path)
        .with_context(|| format!("Failed to resolve absolute path of {hashes_nix_path}"))?;
    let parsed_path = parsed_path.to_str().context("Parsed path would be empty")?;

    let mut hashes_json_cmd = std::process::Command::new("nix-instantiate");
    let hashes_json_cmd = hashes_json_cmd.args([
        "--eval",
        "--expr",
        format!("builtins.toJSON (import {parsed_path})").as_str(),
    ]);
    dbg!(&hashes_json_cmd);
    let hashes_json_cmd = hashes_json_cmd
        .output()
        .with_context(|| format!("failed to execute {hashes_json_cmd:?}"))?;
    if !hashes_json_cmd.stderr.is_empty() {
        bail!(
            "builtins.toJSON on {parsed_path} failed: {}",
            std::str::from_utf8(&hashes_json_cmd.stderr)?
        );
    }

    let hashes_json_unproc = std::str::from_utf8(&hashes_json_cmd.stdout)
        .context("Failed to parse builtins.toJSON output as utf8")?;
    let hashes_json_unproc = &hashes_json_unproc.replace(r#"\""#, r#"""#);
    let hashes_json_unproc = &hashes_json_unproc[1..(hashes_json_unproc.len() - 2)];
    let hashes_json = hashes_json_unproc.trim(); // nix escapes quotes, and adds string doublequotes at the start and end
    return Ok(hashes_json.to_string());
}

async fn get_hash(a: Artifact, client: &reqwest::Client) -> Result<(Artifact, String)> {
    let mut base_url = format!(
        "https://storage.googleapis.com/flutter_infra_release/flutter/{}/{}",
        a.engine_rev, a.platform,
    );

    if let Some(f) = &a.filename {
        base_url += "/";
        base_url += f.as_str();
    }

    let dir_path = format!(
        "{}/{}",
        &ENGINE_UPDATER_TMP_PATH,
        base_url.replace('/', "_")
    );
    dbg!(&dir_path);

    // we cannot use nix-prefetch-url for this as it fails with a hash mismatch.
    // I think this may be because of stripRoot?
    println!("prefetching {}", &base_url);
    let output: Response = client
        .get(&base_url)
        .send()
        .await
        .with_context(|| format!("Failed to fetch {base_url}"))?;
    let mut down = 0;
    // TODO alloc the array before based on the total content size
    let content_len = &output.content_length();
    let content_len: String = content_len.map_or("unknown".to_string(), |x| x.to_string());

    let mut out_stream = output.bytes_stream();
    let mut out_bytes: Vec<u8> = vec![];

    while let Some(c) = out_stream.next().await {
        let c = c?;
        down += &c.len();
        out_bytes.extend(c.as_ref());
        println!("{}: downloaded {}/{}", &dir_path, &down, &content_len);
    }

    // TODO: probably should check if this zip first
    // but for now every artifact is zipped
    let fs_path = std::path::Path::new(&dir_path);
    let out_bytes_u8: &[u8] = out_bytes.as_ref();
    zip_extract::extract(Cursor::new(out_bytes_u8), &fs_path, false)?;

    let mut hash_bytes_cmd = Command::new("nix-hash");
    let hash_bytes_cmd = hash_bytes_cmd.args([&dir_path, "--type", "sha256"]);
    let hash_bytes = hash_bytes_cmd.output().await;
    let hash_bytes = hash_bytes
        .with_context(|| format!("Failed to spawn {:?}", &hash_bytes_cmd))?
        .stdout;

    let hash = std::str::from_utf8(&hash_bytes)
        .with_context(|| format!("Can't parse {:?} output", &hash_bytes_cmd))?
        .trim();
    // remove dir
    tokio::fs::remove_dir_all(&dir_path)
        .await
        .with_context(|| format!("Cannot remove temporary dir at {dir_path}"))?;
    println!("got hash for {}", &base_url);
    let mut sri_cmd = tokio::process::Command::new("nix");
    let sri_cmd = sri_cmd.args([
        "--extra-experimental-features",
        "nix-command",
        "hash",
        "to-sri",
        hash,
        "--type",
        "sha256",
    ]);

    let sri_cmd = sri_cmd
        .output()
        .await
        .with_context(|| format!("Failed to run {sri_cmd:?}"))?
        .stdout;
    let sri = std::str::from_utf8(&sri_cmd)?.trim().to_string();

    return Ok((a, sri));
}
