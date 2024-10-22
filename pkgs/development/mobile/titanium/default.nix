{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "titanium";
  version = "6.1.1";

  src = fetchFromGitHub {
    owner = "tidev";
    repo = "titanium-cli";
    rev = "v${version}";
    hash = "sha256-eJHf4vbapCaIVk0Xc0sml14jkFCsS/Gv7ftaFakB5rI=";
  };

  npmDepsHash = "sha256-60r+zqUCSDvQgrjg5SGfZiv87AoGx1XcnbW1ki1sbCM=";

  dontNpmBuild = true;

  meta = {
    changelog = "https://github.com/tidev/titanium-cli/blob/${src.rev}/CHANGELOG.md";
    description = "Command Line Tool for creating and building Titanium Mobile applications and modules";
    homepage = "https://github.com/tidev/titanium-cli";
    license = lib.licenses.asl20;
    mainProgram = "titanium";
    maintainers = [ ];
  };
}
