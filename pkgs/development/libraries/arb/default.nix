{ lib
, stdenv
, fetchFromGitHub
, mpir
, gmp
, mpfr
, flint
}:

stdenv.mkDerivation rec {
  pname = "arb";
  version = "2.23.0";

  src = fetchFromGitHub {
    owner = "fredrik-johansson";
    repo = pname;
    rev = version;
    sha256 = "sha256-dt9PZ3Xfn60rhmnxYo7CEzNTEUN/wMVAXe8U5PzUO9U=";
  };

  buildInputs = [ mpir gmp mpfr flint ];

  configureFlags = [
    "--with-gmp=${gmp}"
    "--with-mpir=${mpir}"
    "--with-mpfr=${mpfr}"
    "--with-flint=${flint}"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "A library for arbitrary-precision interval arithmetic";
    homepage = "https://arblib.org/";
    license = licenses.lgpl21Plus;
    maintainers = teams.sage.members;
    platforms = platforms.unix;
  };
}
