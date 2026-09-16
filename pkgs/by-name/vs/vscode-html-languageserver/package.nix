{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs,
  typescript_5,
}:

buildNpmPackage (finalAttrs: {
  pname = "vscode-html-languageserver";
  version = "1.136.1";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vscode";
    tag = finalAttrs.version;
    hash = "sha256-Y6FRttdpn353w/ykJbaE+NjM1NfXQewl9Fgux7m10lk=";
  };

  sourceRoot = "${finalAttrs.src.name}/extensions/html-language-features/server";

  npmDepsHash = "sha256-3LdWhp2wJwa0jQgkVZPH3ae8RexS1SU07xaPjM+XcWQ=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    makeBinaryWrapper
    typescript_5
  ];

  preBuild = ''
    ln -s ${typescript_5}/lib/node_modules/typescript node_modules/typescript
  '';

  buildPhase = ''
    runHook preBuild

    tsc -p . \
      --typeRoots ./node_modules/@types \
      --moduleResolution bundler

    runHook postBuild
  '';

  dontNpmBuild = true;

  postInstall = ''
    ln -s ${typescript_5}/lib/node_modules/typescript \
      $out/lib/node_modules/vscode-html-languageserver/node_modules/typescript

    makeBinaryWrapper ${lib.getExe nodejs} $out/bin/vscode-html-languageserver \
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
