{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "valdi";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "Snapchat";
    repo = "Valdi";
    rev = "e4f8ab9fa885ac044121ae61186164e36824f18a";
    hash = "sha256-VWcV7Jg4B50gtMm/6vDZqIo7PG8rqVSA4e9fn3Jw5eI=";
  };

  passthru.updateScript = ./update.sh;

  sourceRoot = "${src.name}/npm_modules/cli";

  npmDepsHash = "sha256-UFdWHEdi6VQYLBQ7gmwxcLNRfoHLKwx4l0ANe5lZnZc=";

  meta = {
    description = "Cross-platform UI framework CLI by Snapchat";
    homepage = "https://github.com/Snapchat/Valdi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jonasfranke ];
    mainProgram = "valdi";
  };
}
