{
  build-idris-package,
  fetchFromGitHub,
  lib,
}:
build-idris-package {
  pname = "transducers";
  version = "2017-07-28";

  src = fetchFromGitHub {
    owner = "QuentinDuval";
    repo = "IdrisReducers";
    rev = "2947ffa3559b642baeb3e43d7bb382e16bd073a8";
    hash = "sha256-2bEKrahrAkf+GCBhbiiR75bLfwoh45qS2nWEYMtd63M=";
  };

  meta = {
    description = "Composable algorithmic transformation";
    homepage = "https://github.com/QuentinDuval/IdrisReducers";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
