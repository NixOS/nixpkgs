{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs,
  typescript,
}:

buildNpmPackage (finalAttrs: {
  pname = "vscode-css-languageserver";
  version = "1.136.1";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vscode";
    tag = finalAttrs.version;
    hash = "sha256-Y6FRttdpn353w/ykJbaE+NjM1NfXQewl9Fgux7m10lk=";
  };

  sourceRoot = "${finalAttrs.src.name}/extensions/css-language-features/server";

  npmDepsHash = "sha256-12WHnmL68AmlZTIvghnBSsKn4zRLJaTtufkwdSbLRQE=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    makeBinaryWrapper
    typescript
  ];

  buildPhase = ''
    runHook preBuild

    tsc -p . \
      --typeRoots ./node_modules/@types \
      --module nodenext \
      --moduleResolution nodenext

    runHook postBuild
  '';

  dontNpmBuild = true;

  postInstall = ''
    makeBinaryWrapper ${lib.getExe nodejs} $out/bin/vscode-css-languageserver \
      --add-flags $out/lib/node_modules/vscode-css-languageserver/out/node/cssServerMain.js
    ln -s $out/bin/vscode-css-languageserver $out/bin/vscode-css-language-server
  '';

  meta = {
    description = "CSS language server";
    homepage = "https://github.com/microsoft/vscode/tree/${finalAttrs.src.tag}/extensions/css-language-features/server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ryota2357 ];
    mainProgram = "vscode-css-languageserver";
  };
})
