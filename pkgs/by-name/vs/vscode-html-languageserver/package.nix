{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs,
  typescript,
}:

buildNpmPackage (finalAttrs: {
  pname = "vscode-html-languageserver";
  version = "1.101.2";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vscode";
    tag = finalAttrs.version;
    hash = "sha256-wdI6VlJ4WoSNnwgkb6dkVYcq/P/yzflv5mE9PuYBVx4=";
  };

  sourceRoot = "${finalAttrs.src.name}/extensions/html-language-features/server";

  npmDepsHash = "sha256-ONORb/r/jowASsdMdDlh0B6b2mG6Gkt2nHTMRSFMZiM=";

  patches = [ ./add-typescript-deps.patch ];

  nativeBuildInputs = [
    makeBinaryWrapper
    typescript
  ];

  buildPhase = ''
    runHook preBuild
    tsc -p .
    runHook postBuild
  '';

  dontNpmBuild = true;

  postInstall = ''
    makeBinaryWrapper ${lib.getExe' nodejs "node"} $out/bin/vscode-html-languageserver \
      --add-flags $out/lib/node_modules/vscode-html-languageserver/out/node/htmlServerMain.js
    ln -s $out/bin/vscode-html-languageserver $out/bin/vscode-html-language-server
  '';

  meta = {
    description = "HTML language server";
    homepage = "https://github.com/microsoft/vscode/tree/${finalAttrs.src.tag}/extensions/html-language-features/server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ryota2357 ];
    mainProgram = "vscode-html-languageserver";
  };
})
