import { lstat, mkdir, readdir, rm, symlink } from "fs/promises";
import { join, relative } from "path";

type PackageManifest = {
  name?: string;
  bin?: string | Record<string, string>;
};

async function isDirectory(path: string) {
  try {
    return (await lstat(path)).isDirectory();
  } catch {
    return false;
  }
}

const bunRoot = join(process.cwd(), "node_modules/.bun");

for (const entry of (await readdir(bunRoot)).sort()) {
  const modulesRoot = join(bunRoot, entry, "node_modules");
  if (!(await isDirectory(modulesRoot))) continue;

  const binRoot = join(modulesRoot, ".bin");
  await rm(binRoot, { recursive: true, force: true });
  await mkdir(binRoot, { recursive: true });

  const packageDirs: string[] = [];
  for (const name of (await readdir(modulesRoot)).sort()) {
    if (name === ".bin" || name === ".bun") continue;

    const dir = join(modulesRoot, name);
    if (!(await isDirectory(dir))) continue;

    if (name.startsWith("@")) {
      for (const child of (await readdir(dir)).sort()) {
        const scopedDir = join(dir, child);
        if (await isDirectory(scopedDir)) packageDirs.push(scopedDir);
      }
    } else {
      packageDirs.push(dir);
    }
  }

  for (const packageDir of packageDirs.sort()) {
    const manifestFile = Bun.file(join(packageDir, "package.json"));
    if (!(await manifestFile.exists())) continue;

    const manifest = (await manifestFile.json()) as PackageManifest;
    if (!manifest.bin) continue;

    const binaries =
      typeof manifest.bin === "string"
        ? [[manifest.name ?? packageDir.split("/").pop(), manifest.bin]]
        : Object.entries(manifest.bin).sort((a, b) => a[0].localeCompare(b[0]));

    for (const [name, target] of binaries) {
      if (!name || !target) continue;

      const source = join(packageDir, target);
      if (!(await Bun.file(source).exists())) continue;

      const destination = join(binRoot, name.slice(name.lastIndexOf("/") + 1));
      await rm(destination, { force: true });
      await symlink(relative(binRoot, source) || ".", destination);
    }
  }
}
