{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "tarts";
  version = "0.1.16-unstable-2025-05-04";

  src = fetchFromGitHub {
    owner = "oiwn";
    repo = "tarts";
    rev = "8560a63dda8e5ffd5fdd96a1f7687f8f12d36022";
    hash = "sha256-d06FL0khcI2LUMbrUo3tmQn97pNFIVefPWlxWFSUJ+E=";
  };

  cargoHash = "sha256-DLIBVl7CzhEYjAnkJmLHSlUoXCNos8YPHfSz9rs99/8=";

  meta = {
    description = "Screen saves and visual effects for your terminal";
    homepage = "https://github.com/oiwn/tarts";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.awwpotato ];
    mainProgram = "tarts";
  };
}
