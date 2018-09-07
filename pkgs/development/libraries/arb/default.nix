{stdenv, fetchFromGitHub, fetchpatch, mpir, gmp, mpfr, flint}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "arb";
  version = "2.14.0";
  src = fetchFromGitHub {
    owner = "fredrik-johansson";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "1ndxg7h4xvccjgp5l9z2f8b66dsff6fhf86bn5n7f75a1ksd7554";
  };
  buildInputs = [mpir gmp mpfr flint];
  configureFlags = [
    "--with-gmp=${gmp}"
    "--with-mpir=${mpir}"
    "--with-mpfr=${mpfr}"
    "--with-flint=${flint}"
  ];
  doCheck = true;
  meta = with stdenv.lib; {
    inherit version;
    description = ''A library for arbitrary-precision interval arithmetic'';
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = with maintainers; [ raskin timokau ];
    platforms = stdenv.lib.platforms.linux;
  };
}
