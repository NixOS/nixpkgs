{
  lib,
  stdenv,
  esbuild,
  buildGoModule,
  fetchFromGitHub,
  fetchgit,
  srcOnly,
  removeReferencesTo,
  nodejs,
  pnpm,
  python3,
  git,
  jq,
  zip,
}:
let
  nodeSources = srcOnly nodejs;
  esbuild' = esbuild.override {
    buildGoModule =
      args:
      buildGoModule (
        args
        // rec {
          version = "0.19.9";
          src = fetchFromGitHub {
            owner = "evanw";
            repo = "esbuild";
            rev = "v${version}";
            hash = "sha256-GiQTB/P+7uVGZfUaeM7S/5lGvfHlTl/cFt7XbNfE0qw=";
          };
          vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
        }
      );
  };
  customPython = python3.withPackages (p: [ p.setuptools ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "taler-wallet-core";
  version = "0.13.3";

  src = fetchgit {
    url = "https://git.taler.net/wallet-core.git";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9pRhaQNnIzbhahMaTVVZqLTlAxh7GZxoz4Gf3TDldAA=";
  };

  nativeBuildInputs = [
    customPython
    nodejs
    pnpm.configHook
    git
    jq
    zip
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-7az1wJ6BK9nPKirtW/fmXo3013JCPf+TNk/aG/mGTfo=";
  };

  buildInputs = [ nodejs ];

  # Make a fake git repo with a commit.
  # Without this, the package does not build.
  postUnpack = ''
    git init -b master
    git config user.email "root@localhost"
    git config user.name "root"
    git commit --allow-empty -m "Initial commit"
  '';

  postPatch = ''
    patchShebangs packages/*/*.mjs
    substituteInPlace pnpm-lock.yaml \
      --replace-fail "esbuild: 0.12.29" "esbuild: ${esbuild'.version}"
  '';

  preConfigure = ''
    ./bootstrap
  '';

  # After the pnpm configure, we need to build the binaries of all instances
  # of better-sqlite3. It has a native part that it wants to build using a
  # script which is disallowed.
  # Adapted from mkYarnModules.
  preBuild = ''
    for f in $(find -path '*/node_modules/better-sqlite3' -type d); do
      (cd "$f" && (
      npm run build-release --offline --nodedir="${nodeSources}"
      find build -type f -exec \
        ${lib.getExe removeReferencesTo} \
        -t "${nodeSources}" {} \;
      ))
    done
  '';

  env.ESBUILD_BINARY_PATH = lib.getExe esbuild';

  meta = {
    homepage = "https://git.taler.net/wallet-core.git/";
    description = "CLI wallet for GNU Taler written in TypeScript and Anastasis Web UI";
    license = lib.licenses.gpl3Plus;
    maintainers = [
      # maintained by the team working on NGI-supported software, no group for this yet
    ];
    platforms = lib.platforms.linux;
    mainProgram = "taler-wallet-cli";
  };
})
