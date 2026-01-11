#!/usr/bin/env nix-shell
/*
#!nix-shell -i node --pure --packages cacert nodejs yq-go nix
*/
import * as assert from "node:assert/strict";
import * as child_process from "node:child_process";
import * as fsPromises from "node:fs/promises";
import * as path from "node:path";

const __dirname = import.meta.dirname;

/** @typedef {{
  rss: {
    channel: {
      item: Array<{
        pubDate: string;
        enclosure: {
          "+@url": string;
          "+@length": string;
          "+@type": string;
          "+@sparkle:version": string;
          "+@sparkle:shortVersionString": string;
        };
      }>
    }
  }
}} UpdatesXmlInfo */

/** @typedef {{
  version: string;
  url: string;
  hash: string;
}} Info */

const UPDATE_URL =
  "https://updateinfo.devmate.com/com.macpaw.site.theunarchiver/updates.xml";

async function main() {
  const filePath = path.join(__dirname, "../info.json");
  /** @type {Info} */
  const oldInfo = JSON.parse(
    await fsPromises.readFile(filePath, { encoding: "utf-8" })
  );

  const response = await fetch(UPDATE_URL);
  assert.ok(response.ok, `Failed to fetch ${UPDATE_URL}`);
  /** @type {UpdatesXmlInfo} */
  const updatesXmlInfo = JSON.parse(
    child_process
      .execSync(`yq eval --input-format=xml --output-format=json`, {
        input: Buffer.from(await response.arrayBuffer()),
      })
      .toString()
  );
  const items = updatesXmlInfo?.rss?.channel?.item;
  assert.ok(Array.isArray(items), "items is required");
  const item = items.sort(
    (a, b) => new Date(b.pubDate).getTime() - new Date(a.pubDate).getTime()
  )[0];
  const {
    "+@url": url,
    "+@sparkle:shortVersionString": version,
    "+@length": fileSize,
  } = item.enclosure;
  assert.ok(url, "url is required");
  assert.ok(version, "version is required");
  assert.ok(fileSize, "fileSize is required");

  if (oldInfo.url === url && oldInfo.version === version) {
    console.log("[update] No updates found");
    return;
  }

  const [prefetchHash, prefetchStorePath] = child_process
    .execSync(`nix-prefetch-url --print-path ${url}`)
    .toString()
    .split("\n");

  const downloadedFileSize = (await fsPromises.stat(prefetchStorePath)).size;
  if (Number(fileSize) !== downloadedFileSize) {
    console.error(
      `File size mismatch: expected ${fileSize}, got ${downloadedFileSize}`
    );
    process.exit(1);
  }
  const hash = child_process
    .execSync(`nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri ${prefetchHash}`)
    .toString()
    .trim();
  /** @type {Info} */
  const info = {
    version,
    url,
    hash,
  };
  console.log(`[update] Updating Notion ${oldInfo.version} -> ${info.version}`);
  await fsPromises.writeFile(filePath, JSON.stringify(info, null, 2) + "\n", {
    encoding: "utf-8",
  });
  console.log("[update] Updating Notion complete");
}

main();
