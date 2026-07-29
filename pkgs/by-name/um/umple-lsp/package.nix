{
  lib,
  pkgsCross,
  buildNpmPackage,
  fetchFromGitHub,
  linkFarm,
  versionCheckHook,
  jre_headless,
  nodejs,
  tree-sitter,
  umple,
  withUmple ? true,
}:
let
  # tree-sitter needs a wasi32 clang available at `bin/clang`
  wasi32cc = lib.getExe pkgsCross.wasi32.stdenv.cc;
  wasi-sdk = linkFarm "wasi-sdk" { "bin/clang" = wasi32cc; };
in
buildNpmPackage (finalAttrs: {
  pname = "umple-lsp";
  version = "1.0.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "umple";
    repo = "umple-lsp";
    # Upstream repo has no tags, so rev is derived from npm version info
    # See ./update.sh
    rev = "1771d55d7e00a720b97c0f2422971efa26e110f6";
    hash = "sha256-44JLteH4q2toLBWQ1YmbFlDHqgF4JufCf8DJCczGayE=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-0RUExwYu/N80cw3LGX4ieOCwSf1LkCICteKIllARhBc=";
  npmFlags = [ "--ignore-scripts" ];
  npmWorkspace = "packages/server";

  nativeBuildInputs = [
    nodejs
    pkgsCross.wasi32.stdenv.cc.bintools
    tree-sitter
  ];

  # Stop tree-sitter from trying to fetch its own wasi-sdk
  env.TREE_SITTER_WASI_SDK_PATH = wasi-sdk;

  dontNpmBuild = true;

  # Same process as the `build-grammar` script from package.json
  buildPhase = ''
    runHook preBuild

    cd packages/tree-sitter-umple
    tree-sitter generate
    tree-sitter build --wasm
    cd -

    npm run copy-wasm
    node_modules/.bin/tsc -b

    runHook postBuild
  '';

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ jre_headless ])
  ]
  ++ lib.optionals withUmple [
    "--set-default"
    "UMPLESYNC_JAR_PATH"
    "${umple}/share/java/umplesync.jar"
  ];

  # Dangling symlinks are left from the npm workspace and aren't used
  dontCheckForBrokenSymlinks = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Umple language server";
    mainProgram = "umple-lsp-server";
    homepage = "https://github.com/umple/umple-lsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MysteryBlokHed ];
  };
})
