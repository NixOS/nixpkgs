{stdenv, fetchFromGitHub, fetchpatch, mpir, gmp, mpfr, flint}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "arb";
  version = "2.16.0";
  src = fetchFromGitHub {
    owner = "fredrik-johansson";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "0478671wfwy3gl26sbxh1jq1ih36z4k72waa8y2y2lvn649gb7cd";
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
