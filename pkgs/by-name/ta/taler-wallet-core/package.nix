{
  lib,
  stdenv,
  esbuild,
  buildGoModule,
  fetchFromGitHub,
  fetchgit,
  srcOnly,
  removeReferencesTo,
  nodejs_20,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  python3,
  gitMinimal,
  jq,
  zip,
}:
let
  nodeSources = srcOnly nodejs_20;
  pnpm' = pnpm_9.override { nodejs = nodejs_20; };
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
  version = "1.3.1";

  src = fetchgit {
    url = "https://git.taler.net/taler-typescript-core.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YTFS4s8GuC3SQ/b4JJ5DbEbzc8hrywYaf6rtSKGiSpE=";
  };

  nativeBuildInputs = [
    customPython
    nodejs_20
    pnpmConfigHook
    pnpm'
    gitMinimal
    jq
    zip
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm';
    fetcherVersion = 1;
    hash = "sha256-jwoSvqE0hqRxu76vDtUOpZxvi4SsmKukfpmp5G6ZV/I=";
  };

  buildInputs = [ nodejs_20 ];

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

  postFixup = ''
    # else it fails to find the python interpreter
    patchShebangs --build $out/bin/taler-helper-sqlite3
  '';

  env.ESBUILD_BINARY_PATH = lib.getExe esbuild';

  meta = {
    homepage = "https://git.taler.net/wallet-core.git/";
    description = "CLI wallet for GNU Taler written in TypeScript and Anastasis Web UI";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.ngi ];
    platforms = lib.platforms.linux;
    mainProgram = "taler-wallet-cli";
    # ./configure doesn't understand --build / --host
    broken = stdenv.buildPlatform != stdenv.hostPlatform;
  };
})
