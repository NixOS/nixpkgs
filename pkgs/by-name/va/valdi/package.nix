{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "valdi";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Snapchat";
    repo = "Valdi";
    rev = "d0f3ae863e218c776af1789bcd9848b148ed1a64";
    hash = "sha256-HJmWPlLC1/2etwEm+xSfOwcbXY1qx+QlM0QgDJ4FIcg=";
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
