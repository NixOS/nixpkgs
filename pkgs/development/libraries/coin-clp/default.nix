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
    sha256 = "txkbKGVJCH4kJR8sESPZihch8gyyzWUeYfuTANgZjHY=";
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
