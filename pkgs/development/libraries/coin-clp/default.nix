{ stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libtool
, coin-utils
, coin-osi
}:

stdenv.mkDerivation rec {
  pname = "coin-clp";
  version = "1.17.7";
  src = fetchFromGitHub {
    owner = "alicevision";
    repo = "clp";
    rev = "4da587acebc65343faafea8a134c9f251efab5b9";
    deepClone = true;
    sha256 = "BWAb73afq+OJsMDCerzulkPaR37Gf1wSOP5N3DGUGtI=";
  };
  nativeBuildInputs = [
    cmake
    pkg-config
    libtool
  ];
  buildInputs = [
    coin-utils
    coin-osi
  ];
}
