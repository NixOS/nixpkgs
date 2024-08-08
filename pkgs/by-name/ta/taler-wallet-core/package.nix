{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  fetchgit,
  esbuild,
  git,
  jq,
  nodejs,
  python3,
  zip,
  pnpm,
  removeReferencesTo,
  srcOnly,
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
stdenv.mkDerivation rec {
  pname = "taler-wallet-core";
  version = "0.12.6";

  src = fetchgit {
    url = "https://git.taler.net/wallet-core.git";
    rev = "v${version}";
    hash = "sha256-gZfXzw3B1Ei2F5o07bpPm6o2alcZ41R6OyhSpew0eTA=";
  };

  nativeBuildInputs = [
    git
    jq
    nodejs
    pnpm.configHook
    customPython
    zip
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    hash = "sha256-OwZLRv2ZWJ01pHWS+CGxvM4J19tGnEsRJ9S3bcsaWSE=";
  };

  buildInputs = [ nodejs ];

  # Make a fale git repo with a commit.
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
}
