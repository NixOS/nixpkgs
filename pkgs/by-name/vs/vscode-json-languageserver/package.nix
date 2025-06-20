{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  typescript,
}:

buildNpmPackage rec {
  pname = "vscode-json-languageserver";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vscode";
    rev = "1.101.1";
    hash = "sha256-ScLyEuQjLdWSrC5JmlK62AW47BrqsZk9ZVvWndPMA/E=";
  };

  sourceRoot = "${src.name}/extensions/json-language-features/server";

  npmDepsHash = "sha256-akQukdYTe6um4xo+7T3wHxx+WrXfKYl5a1qwmqX72HQ=";

  nativeBuildInputs = [ typescript ];

  buildPhase = ''
    runHook preBuild
    tsc -p .
    runHook postBuild
  '';

  dontNpmBuild = true;

  meta = {
    description = "JSON language server";
    homepage = "https://github.com/microsoft/vscode/tree/1.101.1/extensions/json-language-features/server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ryota2357 ];
  };
}
