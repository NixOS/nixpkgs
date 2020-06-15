{stdenv, fetchFromGitHub, mpir, gmp, mpfr, flint}:
stdenv.mkDerivation rec {
  pname = "arb";
  version = "2.18.0";
  src = fetchFromGitHub {
    owner = "fredrik-johansson";
    repo = pname;
    rev = version;
    sha256 = "06yjgmkvr8k0ak0r5j0bbiwa4zsx74mzng5s18n6vsmipfvrqckl";
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
    homepage = "http://arblib.org/";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = with maintainers; [ raskin timokau ];
    platforms = stdenv.lib.platforms.unix;
  };
}
