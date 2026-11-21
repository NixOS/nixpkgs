{
  lib,
  buildLakePackage,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  nodejs,
}:

buildLakePackage (finalAttrs: {
  pname = "lean4-proofwidgets";
  # nixpkgs-update: no auto update
  version = "0.0.120-unstable-2026-11-16";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "ProofWidgets4";
    rev = "2f0f3520daeac2d9310ff25b7a877a0e5cdaa203";
    hash = "sha256-+BPCDJTZwPz+8p6mKy0c+W2QUErgGQF2RmQxcimxFCs=";
  };

  leanPackageName = "proofwidgets";

  lakeHash = null;

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  npmDeps = fetchNpmDeps {
    name = "lean4-proofwidgets-npm-deps";
    src = finalAttrs.src;
    sourceRoot = "source/widget";
    hash = "sha256-z3LCBPmowLlkn5w/z72J1l8WnY60F8I7r48HMM/Lnns=";
  };
  npmRoot = "widget";

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
})
