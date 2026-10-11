{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  jre_headless,
  nodejs,
  tree-sitter,
  umple,
  withUmple ? true,
}:
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
    (tree-sitter.override { wasmSupport = true; })
  ];

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
