{stdenv, fetchFromGitHub, fetchpatch, mpir, gmp, mpfr, flint}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "arb";
  version = "2.15.0";
  src = fetchFromGitHub {
    owner = "fredrik-johansson";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "04jwa39fa7k8r3vwhzjwgq76gc30pjs60nvrw5b80ippyybd2vi5";
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
