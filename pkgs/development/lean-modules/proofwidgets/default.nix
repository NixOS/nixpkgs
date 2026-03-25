{
  lib,
  buildLakePackage,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  nodejs,
}:

let
  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "ProofWidgets4";
    tag = "v0.0.87";
    hash = "sha256-qXEqNfwUBPnxAtLRkBZTBFhrM4JYl43gLo/PM6HOG7o=";
  };
in

buildLakePackage {
  pname = "lean4-proofwidgets";
  version = "0.0.87";

  inherit src;

  leanPackageName = "proofwidgets";

  # ProofWidgets has no Lean dependencies (lake-manifest.json packages = []).
  lakeHash = null;

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  # Pre-fetched npm dependencies for the TypeScript widget build
  # (npm/rollup in widget/).  npmConfigHook installs these offline.
  npmDeps = fetchNpmDeps {
    name = "lean4-proofwidgets-npm-deps";
    inherit src;
    sourceRoot = "source/widget";
    hash = "sha256-CzBRrreOSytquZ/xFHPlY8r+lz5Bg9Zk9ienRhc8SiY=";
  };
  npmRoot = "widget";

  # Lake's widgetJsAll target runs `npm clean-install` which wipes
  # node_modules and the patched shebangs that npmConfigHook applied.
  # Wrap npm to skip ci/clean-install (deps already installed) while
  # passing `npm run build` through — same pattern as llama-cpp/evcc.
  postConfigure = ''
    local realNpm
    realNpm="$(type -P npm)"
    mkdir -p "$TMPDIR/npm-wrap"
    cat > "$TMPDIR/npm-wrap/npm" <<WRAPPER
    #!/bin/sh
    case "\$1" in ci|clean-install) exit 0 ;; esac
    exec "$realNpm" "\$@"
    WRAPPER
    chmod +x "$TMPDIR/npm-wrap/npm"
    export PATH="$TMPDIR/npm-wrap:$PATH"
  '';

  meta = {
    description = "Interactive UI framework for Lean 4 proof assistants";
    homepage = "https://github.com/leanprover-community/ProofWidgets4";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nadja-y ];
  };
}
