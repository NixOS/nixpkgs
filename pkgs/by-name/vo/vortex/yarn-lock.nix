# Builds a merged yarn.lock with unique keys so fetchYarnDeps downloads ALL
# packages from every lockfile (root + app + ~50 extensions) without losing
# entries to key collisions during parse().
{
  runCommand,
  nodejs,
  fixup-yarn-lock,
  src,
}:
runCommand "vortex-merged-yarn-lock" {
  nativeBuildInputs = [nodejs];
  inherit src;
} ''
  node -e '
    const fs = require("fs");
    const path = require("path");
    const lockfile = require("${fixup-yarn-lock}/libexec/yarnpkg-lockfile.js");

    const src = process.env.src;
    const locks = [];
    const walk = (dir) => {
      for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
        if (e.name === "node_modules" || e.name === ".git") continue;
        const full = path.join(dir, e.name);
        if (e.isDirectory()) walk(full);
        else if (e.name === "yarn.lock") locks.push(full);
      }
    };
    walk(src);

    const merged = {};
    let idx = 0;
    for (const lp of locks) {
      const parsed = lockfile.parse(fs.readFileSync(lp, "utf8"));
      for (const [key, val] of Object.entries(parsed.object)) {
        if (!val.resolved) continue;
        merged["__m" + (idx++) + "@" + val.version] = val;
      }
    }
    fs.writeFileSync(process.env.out, lockfile.stringify(merged));
  '
''
