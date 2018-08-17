{stdenv, fetchFromGitHub, mpir, gmp, mpfr, flint}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "arb";
  version = "2.9.0pre20161013";
  src = fetchFromGitHub {
    owner = "fredrik-johansson";
    repo = "${pname}";
    rev = "10bc615ce5999caf4723444b2b1219b74781d8a4";
    sha256 = "1xb40x3hv9nh76aizhskj5gdhalgn7r95a7zji2nn4ih3lmh40hl";
  };
  buildInputs = [ mpir gmp mpfr flint ];
  configureFlags = [ "--with-gmp=${gmp}" "--with-mpir=${mpir}" "--with-mpfr=${mpfr}" "--with-flint=${flint}" ];
  meta = {
    inherit version;
    description = ''A library for arbitrary-precision interval arithmetic'';
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
