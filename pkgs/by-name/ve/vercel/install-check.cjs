const assert = require('node:assert/strict');
const { createRequire } = require('node:module');
const path = require('node:path');
const fs = require('node:fs');
const os = require('node:os');
const { execFileSync } = require('node:child_process');

const cliRequire = createRequire(
  path.join(process.env.out, 'lib/node_modules/vercel/package.json'),
);
const buildUtilsRequire = createRequire(
  cliRequire.resolve('@vercel/build-utils'),
);
const analysis = buildUtilsRequire('@vercel/python-analysis');

async function main() {
  // These native dependencies are loaded lazily by the CLI and its builders.
  for (const name of ['@napi-rs/keyring', 'oxc-parser', 'oxc-transform', 'rolldown']) {
    cliRequire(name);
  }
  assert.equal(
    cliRequire('esbuild').transformSync('const x: number = 1', { loader: 'ts' }).code,
    'const x = 1;\n',
  );

  // Loading the CLI does not instantiate the lazily loaded Wasm component.
  // Exercise it from the installed dependency tree to check its assets and imports.
  assert.equal(
    await analysis.findAppOrHandler(
      'from flask import Flask\napp = Flask(__name__)',
    ),
    'app',
  );
  assert.equal(await analysis.findAppOrHandler('app = ('), null);
  assert.equal(
    await analysis.getStringConstant('VERSION = "1.2.3"', 'VERSION'),
    '1.2.3',
  );

  const pkg = cliRequire('./package.json');
  for (const [name, version] of Object.entries(pkg.builders)) {
    assert.match(version, /^\d+\.\d+\.\d+/);
    assert.ok(cliRequire.resolve(name), `${name} must be installed`);
  }

  const project = fs.mkdtempSync(path.join(os.tmpdir(), 'vercel-test-'));
  fs.mkdirSync(path.join(project, '.vercel'));
  fs.mkdirSync(path.join(project, 'public'));
  fs.writeFileSync(
    path.join(project, '.vercel/project.json'),
    JSON.stringify({
      projectId: 'prj_nixpkgs_test',
      orgId: 'team_nixpkgs_test',
      projectName: 'nixpkgs-test',
      settings: {
        framework: null,
        buildCommand: 'npm run build',
        installCommand: '',
        outputDirectory: 'public',
        rootDirectory: null,
        nodeVersion: '24.x',
      },
    }),
  );
  fs.writeFileSync(
    path.join(project, 'package.json'),
    JSON.stringify({
      name: 'nixpkgs-vercel-test',
      version: '1.0.0',
      private: true,
      scripts: {
        build:
          "node -e \"require('node:fs').writeFileSync('public/index.html', 'nixpkgs-vercel-test')\"",
      },
    }),
  );
  execFileSync(
    path.join(process.env.out, 'bin/vercel'),
    ['build', '--cwd', project],
    {
      stdio: 'inherit',
      timeout: 60_000,
      env: {
        ...process.env,
        // Keep only the shell on PATH to check that the wrapper supplies node and npm.
        PATH: path.dirname(process.argv[2]),
        CI: '1',
        VERCEL_TELEMETRY_DISABLED: '1',
      },
    },
  );
  assert.equal(
    fs.readFileSync(
      path.join(project, '.vercel/output/static/index.html'),
      'utf8',
    ),
    'nixpkgs-vercel-test',
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
