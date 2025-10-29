{
  lib,
  crystal,
  fetchFromGitHub,
}:

crystal.buildCrystalPackage rec {
  pname = "thicket";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "taylorthurlow";
    repo = "thicket";
    rev = "v${version}";
    sha256 = "sha256-sF+fNKEZEfjpW3buh6kFUpL1P0yO9g4SrTb0rhx1uNc=";
  };

  format = "shards";

  crystalBinaries.thicket.src = "src/thicket.cr";

  # there is one test that tries to clone a repo
  doCheck = false;

  meta = {
    description = "Better one-line git log";
    homepage = "https://github.com/taylorthurlow/thicket";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    mainProgram = "thicket";
  };
}
