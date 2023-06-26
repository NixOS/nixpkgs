use crate::ENGINE_UPDATER_TMP_PATH;
use crate::{verbose_print, wc};
use anyhow::Context;
use reqwest::Response;
use std::io::Cursor;
use tokio::process::Command;

#[derive(Debug)]
pub struct Artifact<'a> {
    pub engine_rev: &'a str,
    pub platform: String,
    pub filename: Option<String>,
}

static mut TOTAL_TASKS: f32 = 0.0;
static mut TASKS_COMPLETED: f32 = 0.0;
impl Artifact<'_> {
    pub fn get_download_url(&self) -> String {
        let mut url = format!(
            "https://storage.googleapis.com/flutter_infra_release/flutter/{}/{}",
            self.engine_rev, self.platform,
        );
        if let Some(f) = &self.filename {
            url += "/";
            url += f.as_str();
        }
        url
    }
    pub fn get_log_identifier(&self) -> String {
        let mut url = self.platform.clone();
        if let Some(f) = &self.filename {
            url += "/";
            url += f.as_str();
        }
        url
    }

    pub async fn get_hash(&self, client: &reqwest::Client) -> anyhow::Result<String> {
        //verbose_print!("get_hash {a:?}");
        unsafe {
            TOTAL_TASKS += 1.0;
        }
        let log_identifier = self.get_log_identifier();
        let base_url = self.get_download_url();

        let dir_path = format!("{ENGINE_UPDATER_TMP_PATH}/{}", base_url.replace('/', "_"));

        // we cannot use nix-prefetch-url for this as it fails with a hash mismatch.
        // I think this may be because of stripRoot?
        let output: Response = wc!(
            client.get(&base_url).send().await,
            "Failed to fetch {base_url}"
        )?
        .error_for_status()?;
        verbose_print!("get_hash({log_identifier}): {}", output.status());
        let out_bytes = wc!(
            output.bytes().await,
            "Failed to get response bytes of {log_identifier} (url={base_url})"
        )?;
        // TODO: probably should check if this zip first
        // but for now every artifact is zipped
        let fs_path = std::path::Path::new(&dir_path);
        zip_extract::extract(Cursor::new(&out_bytes), &fs_path, false)
            .with_context(|| format!("Downloaded from {base_url}"))
            .with_context(|| {
                format!(
                    "File contents: {}",
                    (std::str::from_utf8(&out_bytes)
                        .unwrap_or("Cannot show contents, failed to parse it as utf8"))
                )
            })
            .with_context(|| format!("Failed to extract {dir_path}",))?;

        let mut hash_bytes_cmd = Command::new("nix-hash");
        let hash_bytes_cmd = hash_bytes_cmd.args([&dir_path, "--type", "sha256"]);
        let hash_bytes = wc!(
            hash_bytes_cmd.output().await,
            "Failed to spawn {hash_bytes_cmd:?}"
        )?
        .stdout;

        let hash = wc!(
            std::str::from_utf8(&hash_bytes),
            "Failed to parse {hash_bytes_cmd:?} output"
        )?
        .trim();
        // remove dir
        wc!(
            tokio::fs::remove_dir_all(&dir_path).await,
            "Cannot remove temporary dir at {dir_path}"
        )?;
        //println!("got hash for {}", &base_url);
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

        unsafe {
            TASKS_COMPLETED += 1.0;
        }
        eprint!(
            "\rProcessed {:.0}%",
            unsafe { TASKS_COMPLETED / TOTAL_TASKS } * 100.0
        );
        return Ok(sri);
    }
}
