{
  build-idris-package,
  fetchFromGitHub,
  lib,
}:
build-idris-package {
  pname = "pipes";
  version = "2017-12-02";

  src = fetchFromGitHub {
    owner = "QuentinDuval";
    repo = "IdrisPipes";
    rev = "888abe405afce42015014899682c736028759d42";
    hash = "sha256-ejUL9vBtFCEWoljA80I55cvG/fUYyFmXmvR4DN7Hq7c=";
  };

  meta = {
    description = "Composable and effectful production, transformation and consumption of streams of data";
    homepage = "https://github.com/QuentinDuval/IdrisPipes";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
