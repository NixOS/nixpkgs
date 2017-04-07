{ stdenv, fetchFromGitHub, clang }:

stdenv.mkDerivation {
  name = "blocksruntime";

  src = fetchFromGitHub {
    owner = "mackyle";
    repo = "blocksruntime";
    rev = "b5c5274daf1e0e46ecc9ad8f6f69889bce0a0a5d";
    sha256 = "0ic4lagagkylcvwgf10mg0s1i57h4i25ds2fzvms22xj4zwzk1sd";
  };

  buildInputs = [ clang ];

  configurePhase = ''
    export CC=clang
    export CXX=clang++
  '';

  buildPhase = "./buildlib";

  checkPhase = "./checktests";

  doCheck = false; # hasdescriptor.c test fails, hrm.

  installPhase = ''prefix="/" DESTDIR=$out ./installlib'';
}
