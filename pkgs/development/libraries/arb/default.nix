{ lib, stdenv, fetchFromGitHub, mpir, gmp, mpfr, flint }:

stdenv.mkDerivation rec {
  pname = "arb";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "fredrik-johansson";
    repo = pname;
    rev = version;
    sha256 = "05lpy3hkl5f8ik19aw40cqydrb932xaf2n8hbq9ib5dnk7f010p1";
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
