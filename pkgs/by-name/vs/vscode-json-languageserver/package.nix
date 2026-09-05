{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs,
  typescript,
}:

buildNpmPackage (finalAttrs: {
  pname = "vscode-json-languageserver";
  version = "1.136.1";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vscode";
    tag = finalAttrs.version;
    hash = "sha256-Y6FRttdpn353w/ykJbaE+NjM1NfXQewl9Fgux7m10lk=";
  };

  sourceRoot = "${finalAttrs.src.name}/extensions/json-language-features/server";

  npmDepsHash = "sha256-kVZ7pnC/3m0I1jwuN3Ad6carWpj+O7IYnRZ3cx5W00g=";

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

  # Upstream's bin script still uses require() in a "type": "module" package.
  postInstall = ''
    rm $out/bin/vscode-json-languageserver
    makeBinaryWrapper ${lib.getExe nodejs} $out/bin/vscode-json-languageserver \
      --add-flags $out/lib/node_modules/vscode-json-languageserver/out/node/jsonServerMain.js

    ln -s $out/bin/vscode-json-languageserver $out/bin/vscode-json-language-server
  '';

  meta = {
    description = "JSON language server";
    homepage = "https://github.com/microsoft/vscode/tree/${finalAttrs.src.tag}/extensions/json-language-features/server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ryota2357 ];
    mainProgram = "vscode-json-languageserver";
  };
})
