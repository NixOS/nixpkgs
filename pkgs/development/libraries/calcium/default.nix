{ lib
, stdenv
, fetchFromGitHub
, mpir
, gmp
, mpfr
, flint
, arb
, antic
}:

stdenv.mkDerivation rec {
  pname = "calcium";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "fredrik-johansson";
    repo = pname;
    rev = version;
    sha256 = "sha256-Ony2FGMnWyNqD7adGeiDtysHNZ4ClMvQ1ijVPSHJmyc=";
  };

  buildInputs = [ mpir gmp mpfr flint arb antic ];

  configureFlags = [
    "--with-gmp=${gmp}"
    "--with-mpir=${mpir}"
    "--with-mpfr=${mpfr}"
    "--with-flint=${flint}"
    "--with-arb=${arb}"
    "--with-antic=${antic}"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "C library for exact computation with real and complex numbers";
    homepage = "https://fredrikj.net/calcium/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ smasher164 ];
    platforms = platforms.unix;
  };
}
