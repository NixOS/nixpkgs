#!/usr/bin/env nix-shell
/*
#!nix-shell -i node --pure --packages cacert nodejs_latest
*/
import * as assert from "node:assert/strict";
import * as fsPromises from "node:fs/promises";
import * as path from "node:path";
import * as process from "node:process";

const __dirname = import.meta.dirname;
const __filename = import.meta.filename;

interface LatestInfo {
  readonly url: string;
  readonly sha256hash: string;
  readonly windsurfVersion: string;
  readonly productVersion: string;
}

const platforms = ["aarch64-darwin", "x86_64-darwin", "x86_64-linux"] as const;
type Platform = (typeof platforms)[number];
type InfoMap = Record<
  Platform,
  {
    readonly version: string;
    readonly vscodeVersion: string;
    readonly url: string;
    readonly sha256: string;
  }
>;

async function getInfo(targetSystem: "darwin-arm64" | "darwin-x64" | "linux-x64") {
  const url =
    `https://windsurf-stable.codeium.com/api/update/${targetSystem}/stable/latest` as const;

  const response = await fetch(url);
  assert.ok(response.ok, `Failed to fetch ${url}`);

  const latestInfo: LatestInfo = JSON.parse(await response.text());
  assert.ok(latestInfo.sha256hash, "sha256hash is required");
  assert.ok(latestInfo.url, "url is required");
  assert.ok(latestInfo.windsurfVersion, "windsurfVersion is required");
  assert.ok(latestInfo.productVersion, "productVersion is required");
  return {
    version: latestInfo.windsurfVersion,
    vscodeVersion: latestInfo.productVersion,
    url: latestInfo.url,
    sha256: latestInfo.sha256hash,
  };
}

async function main() {
  const filePath = path.join(__dirname, "../info.json");
  const oldInfo = JSON.parse(
    await fsPromises.readFile(filePath, { encoding: "utf-8" }),
  );

  const info: InfoMap = {
    "aarch64-darwin": await getInfo("darwin-arm64"),
    "x86_64-darwin": await getInfo("darwin-x64"),
    "x86_64-linux": await getInfo("linux-x64"),
  };
  if (JSON.stringify(oldInfo) === JSON.stringify(info)) {
    console.log("[update] No updates found");
    return;
  }
  for (const platform of platforms) {
    console.log(
      `[update] Updating Windsurf ${platform} ${oldInfo[platform].version} -> ${info[platform].version}`,
    );
  }
  await fsPromises.writeFile(
    filePath,
    JSON.stringify(info, null, 2) + "\n",
    "utf-8",
  );
  console.log("[update] Updating Windsurf complete");
}

if (process.argv[1] === __filename) {
  main();
}
