{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs,
  typescript_7,
}:

buildNpmPackage (finalAttrs: {
  pname = "vscode-json-languageserver";
  version = "1.138.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vscode";
    tag = finalAttrs.version;
    hash = "sha256-PQqCs0tXjwEMjvHCuIRO6lc4ih2vISMrtXZrgl4Jypg=";
  };

  sourceRoot = "${finalAttrs.src.name}/extensions/json-language-features/server";

  npmDepsHash = "sha256-4VqxQYvCaKemc/Tr99bu47PHfmjCJ/KfljMn4bAydog=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    makeBinaryWrapper
    typescript_7
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
