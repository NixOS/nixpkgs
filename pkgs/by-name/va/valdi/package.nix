{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "valdi";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "Snapchat";
    repo = "Valdi";
    rev = "e5bec35276f9aa5727384252fdeefff98dd53d6c";
    hash = "sha256-cXLSZK7duxdgkAnDDJRDgEVdiz6dt08A7KvrmBfX37c=";
  };

  passthru.updateScript = ./update.sh;

  sourceRoot = "${src.name}/npm_modules/cli";

  npmDepsHash = "sha256-h1DuH8HE5T7mEBQKlegbqkvRQSx3yEFJhcNVHh5Uo6Y=";

  meta = {
    description = "Cross-platform UI framework CLI by Snapchat";
    homepage = "https://github.com/Snapchat/Valdi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jonasfranke ];
    mainProgram = "valdi";
  };
}
