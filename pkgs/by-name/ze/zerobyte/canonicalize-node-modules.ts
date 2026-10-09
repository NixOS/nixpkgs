import { lstat, mkdir, readdir, rm, symlink } from "fs/promises";
import { join, relative } from "path";

type Entry = {
  dir: string;
  version: string;
};

async function isDirectory(path: string) {
  try {
    return (await lstat(path)).isDirectory();
  } catch {
    return false;
  }
}

const root = process.cwd();
const bunRoot = join(root, "node_modules/.bun");
const linkRoot = join(bunRoot, "node_modules");
const versions = new Map<string, Entry[]>();

for (const label of (await readdir(bunRoot)).sort()) {
  const dir = join(bunRoot, label);
  if (!(await isDirectory(dir))) continue;

  const marker = label.startsWith("@") ? label.indexOf("@", 1) : label.indexOf("@");
  if (marker <= 0) continue;

  const name = label.slice(0, marker).replaceAll("+", "/");
  const version = label.slice(marker + 1);
  const entries = versions.get(name) ?? [];
  entries.push({ dir, version });
  versions.set(name, entries);
}

await rm(linkRoot, { recursive: true, force: true });
await mkdir(linkRoot, { recursive: true });

for (const [name, entries] of Array.from(versions.entries()).sort((a, b) => a[0].localeCompare(b[0]))) {
  entries.sort((a, b) => {
    const aValid = Bun.semver.satisfies(a.version, "x.x.x");
    const bValid = Bun.semver.satisfies(b.version, "x.x.x");
    if (aValid && bValid) return -Bun.semver.order(a.version, b.version);
    if (aValid) return -1;
    if (bValid) return 1;
    return b.version.localeCompare(a.version);
  });

  const selected = entries[0];
  const parts = name.split("/");
  const leaf = parts.pop();
  if (!selected || !leaf) continue;

  const parent = join(linkRoot, ...parts);
  const target = join(selected.dir, "node_modules", name);
  if (!(await isDirectory(target))) continue;

  await mkdir(parent, { recursive: true });
  await symlink(relative(parent, target) || ".", join(parent, leaf));
}
