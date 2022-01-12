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
  version = "2.21.1";

  src = fetchFromGitHub {
    owner = "fredrik-johansson";
    repo = pname;
    rev = version;
    sha256 = "sha256-OBY2gKVnvrZLVrv+d6rXQLo026mrGB9eyNV4LESgrNI=";
  };

  buildInputs = [ mpir gmp mpfr flint ];

  configureFlags = [
    "--with-gmp=${gmp}"
    "--with-mpir=${mpir}"
    "--with-mpfr=${mpfr}"
    "--with-flint=${flint}"
  ];

  doCheck = true;

  meta = with lib; {
    description = "A library for arbitrary-precision interval arithmetic";
    homepage = "https://arblib.org/";
    license = licenses.lgpl21Plus;
    maintainers = teams.sage.members;
    platforms = platforms.unix;
  };
}
