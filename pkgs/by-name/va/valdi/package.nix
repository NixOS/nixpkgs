{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "valdi";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "Snapchat";
    repo = "Valdi";
    rev = "57fba0055df5351fa5019168fa164b6e80ed7816";
    hash = "sha256-vduG/WPhh6zRC5JACav2FPQQZHhdFHfo3wsnncgfFvE=";
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
