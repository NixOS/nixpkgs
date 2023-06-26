use anyhow::Context;
use std::{
    io::Write,
    process::{ChildStdout, Command, Stdio},
};

pub fn format(content: &str) -> anyhow::Result<ChildStdout> {
    let fmt_cmd = Command::new("nixpkgs-fmt")
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .spawn()
        .context("Failed to format output with nixpkgs-fmt")?;

    fmt_cmd
        .stdin
        .context("Failed to grab stdin of nixpkgs-fmt process")?
        .write_all(content.as_bytes())
        .context("Failed to write into nixpkgs-fmt process stdin")?;

    fmt_cmd
        .stdout
        .context("Failed to grab stdout of nixpkgs-fmt process")
}
