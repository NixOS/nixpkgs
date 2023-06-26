use std::process::Command;

use anyhow::Context;

use crate::wc;

pub fn json2nix(json: &str) -> anyhow::Result<String> {
    let mut nix = Command::new("nix-instantiate");
    let nix = nix
        .args([
            "--expr",
            "--eval",
            format!("builtins.fromJSON ''{json}''").as_str(),
        ])
        .output()
        .with_context(|| format!("Failed to run {nix:?}"))?
        .stdout;

    Ok(wc!(
        std::str::from_utf8(&nix),
        "Failed to parse json-to-nix output as utf8"
    )?
    .replace('{', "{\n")
    .replace('}', "\n}"))
}
