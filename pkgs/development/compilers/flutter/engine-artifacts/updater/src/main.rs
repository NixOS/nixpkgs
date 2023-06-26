// This file is written in the crab lang because getting jq quotation
// to work correctly in bash correctly was too much.
// Also, this provides a speed improvement.
#![warn(clippy::pedantic)]
use anyhow::{bail, Context, Result};
use serde_json::{Map, Value};
use std::{
    fs::OpenOptions,
    io::{self, stdout},
};

mod nix_serde;
pub use nix_serde::*;

mod artifact;
pub use artifact::*;

mod format;
pub use format::*;

mod args;
pub use args::*;

const ENGINE_UPDATER_TMP_PATH: &str = "engine-updater-tmp";
const HELP_MSG: &str = r#"
engine-updater: Update flutter engine hashes.json
USAGE: engine-updater <args> <old hashes.nix file>

ARGS:
    -v, --verbose: Print more logs
    -c, --channel: Specify channel to get engine version info from. Defaults to `stable`.
    -p, --print: Print the new hashes.nix to stdout, instead of modifying it in-place.
    -h, --help: display this help message
    --thirdparty: display thirdparty notices
"#;

#[macro_export]
macro_rules! wc {
    ($what:expr, $($fmt_arg:expr),+) => {
        $what.with_context(|| format!( $($fmt_arg),* ))
    };
}

static mut VERBOSE: bool = false;
#[macro_export]
macro_rules! verbose_print {
    ($($arg:expr),+) => {
        unsafe {
            if crate::VERBOSE {
                eprintln!($($arg),*);
            }
        }
    }
}

#[tokio::main]
async fn actual_main() -> anyhow::Result<()> {
    // I don't want to add another dep for an arg parser this simple
    let args = parse_args().context("Failed to parse CLI args")?;
    verbose_print!("running with {args:?}");

    let client = reqwest::Client::new();

    wc!(
        tokio::fs::create_dir_all(ENGINE_UPDATER_TMP_PATH).await,
        "Failed to create directory at {ENGINE_UPDATER_TMP_PATH}"
    )?;

    let mut hashes_map_raw: Value = serde_json::from_str(
        get_hashes_json(&args.hashes_nix_path)
            .context("Failed to get contents of the old hashes.nix")?
            .as_str(),
    )
    .context("Failed to parse the nix-to-json output to json")?;

    let hashes_map: &mut Map<String, Value> = hashes_map_raw
        .as_object_mut()
        .context("Failed to get hashes_map as an object, maybe the json isn't valid?")?;
    let new_engine_rev = get_engine_rev(&client, args.channel)
        .await
        .context("Failed to get engine revision")?;
    let new_engine_rev = new_engine_rev.as_str();

    let first_key = wc!(
        hashes_map.keys().next(),
        "Failed to get the first key from {}, maybe it's is empty?",
        &args.hashes_nix_path
    )?;

    // copy the last key for correct structure
    hashes_map.insert(new_engine_rev.to_string(), hashes_map[first_key].clone());
    let new_entry: &mut Map<String, Value> = wc!(
        hashes_map[new_engine_rev].as_object_mut(),
        "Failed to get key {new_engine_rev} from json"
    )?;

    let mut all_fetchers = vec![];

    for (platform, value) in new_entry {
        if let Some(val_map) = value.as_object_mut() {
            verbose_print!("- {platform} (object)");

            for (filename, _hash) in val_map {
                verbose_print!("  - {filename}");
                let a = Artifact {
                    engine_rev: new_engine_rev,
                    // I don't know of any way to avoid
                    // cloning here, since then the json would be partially moved
                    filename: Some(filename.to_string()),
                    platform: platform.to_string(),
                };
                all_fetchers.push(get_hash_failfast(a, &client));
            }
        } else {
            verbose_print!("- {platform} (not object)");
            let a = Artifact {
                engine_rev: new_engine_rev,
                filename: None,
                platform: platform.to_string(),
            };

            all_fetchers.push(get_hash_failfast(a, &client));
        }
    }

    let fetched = futures::future::join_all(all_fetchers).await;
    verbose_print!("\nfinished getting sources");

    // insert everything here
    for (artifact, hash) in fetched {
        let mut path = &mut hashes_map[artifact.engine_rev][&artifact.platform];
        if let Some(x) = &artifact.filename {
            path = &mut hashes_map[artifact.engine_rev][&artifact.platform][x];
        }
        *path = hash.into();
    }

    let final_json = serde_json::to_string_pretty(&hashes_map_raw)
        .context("Failed to print final json to string")?;
    let nix_contents = json2nix(&final_json).context("json2nix on final json failed")?;

    // format the file because else it is a very ugly one-liner
    let mut fmt_stdout = format(&nix_contents).context("Failed to format final hashes.nix")?;
    if args.print {
        io::copy(&mut fmt_stdout, &mut stdout().lock())
            .context("Failed to write final json into stdout")?;
        return Ok(());
    }

    let mut hashes = wc!(
        OpenOptions::new()
            .write(true)
            .create(true)
            .truncate(true)
            .open(&args.hashes_nix_path),
        "Failed to open {}",
        &args.hashes_nix_path
    )?;

    wc!(
        io::copy(&mut fmt_stdout, &mut hashes),
        "Failed to write final contents to {}",
        &args.hashes_nix_path
    )?;

    Ok(())
}

fn main() {
    let a = actual_main();
    cleanup();
    a.unwrap();
}

async fn get_engine_rev(client: &reqwest::Client, version: Option<String>) -> Result<String> {
    let url = format!(
        "https://raw.githubusercontent.com/flutter/flutter/{}/bin/internal/engine.version",
        version.unwrap_or("stable".into())
    );

    let res = client
        .get(&url)
        .send()
        .await
        .with_context(|| format!("Failed to request {url}"))?
        .error_for_status()
        .with_context(|| format!("Requested {url}, but got error"))?
        .text()
        .await
        .with_context(|| format!("Failed to get body of {url}"))?;

    verbose_print!("get_engine_rev({url}) -> {res}");
    Ok(res.trim().replace('\n', ""))
}

fn get_hashes_json(hashes_nix_path: &str) -> Result<String> {
    // `import hashes.nix` is not valid nix (hashes.nix here is not a path), so
    // we make it absolute, and then use `import /full/directory/hashes.nix`.
    // This has the added benefit of error-ing when the file doesn't exist.
    let parsed_path = wc!(
        std::fs::canonicalize(hashes_nix_path),
        "Failed to resolve absolute path of {hashes_nix_path}"
    )?;

    let parsed_path = wc!(
        parsed_path.to_str(),
        "Parsed path of hashes.json ({parsed_path:?}) not valid on the current platform"
    )?;

    let mut hashes_json_cmd = std::process::Command::new("nix-instantiate");
    let hashes_json_cmd = hashes_json_cmd.args([
        "--eval",
        "--expr",
        format!("builtins.toJSON (import {parsed_path})").as_str(),
    ]);

    let hashes_json_cmd = wc!(
        hashes_json_cmd.output(),
        "failed to get output of {hashes_json_cmd:?}"
    )?;

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

    verbose_print!("get_hashes_json({hashes_nix_path}) -> {hashes_json}");
    return Ok(hashes_json.to_string());
}

async fn get_hash_failfast<'a>(
    a: Artifact<'a>,
    client: &reqwest::Client,
) -> (Artifact<'a>, String) {
    let hash_result = a.get_hash(client).await;
    if let Ok(hash) = hash_result {
        return (a, hash);
    } else {
        // This is written this way, because
        // - we want to early exit if one download fails,
        //   the hashes.nix file can only be generated if all hashes are known
        //  BUT
        // - we cannot return a result, since futures::join_all() only takes impl Future's, not
        // Result<Impl Future>s. We could return a Future<Result>, but that wouldn't allow for
        // early exiting.
        cleanup();
        hash_result.unwrap();
        unreachable!();
    }
}

fn cleanup() {
    std::fs::remove_dir_all(&ENGINE_UPDATER_TMP_PATH)
        .with_context(|| format!("Failed to delete temp dir at {ENGINE_UPDATER_TMP_PATH}"))
        .unwrap();
}
