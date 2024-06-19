{ build-idris-package
, fetchFromGitHub
, lib
}:
build-idris-package  {
  pname = "transducers";
  version = "2017-07-28";

  src = fetchFromGitHub {
    owner = "QuentinDuval";
    repo = "IdrisReducers";
    rev = "2947ffa3559b642baeb3e43d7bb382e16bd073a8";
    sha256 = "0wzbbp5n113mva99mqr119zwp5pgj4l6wq9033z4f0kbm2nhmcfr";
  };

  meta = {
    description = "Composable algorithmic transformation";
    homepage = "https://github.com/QuentinDuval/IdrisReducers";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
