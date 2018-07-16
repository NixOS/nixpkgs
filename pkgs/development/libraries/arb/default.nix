{stdenv, fetchFromGitHub, fetchpatch, mpir, gmp, mpfr, flint}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "arb";
  version = "2.13.0";
  src = fetchFromGitHub {
    owner = "fredrik-johansson";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "1fl9gmxf6c1cphk5r8jbys5pywj2rfm705kv0055i0aqc6hrv303";
  };
  buildInputs = [mpir gmp mpfr flint];
  configureFlags = [
    "--with-gmp=${gmp}"
    "--with-mpir=${mpir}"
    "--with-mpfr=${mpfr}"
    "--with-flint=${flint}"
  ];
  doCheck = true;
  patches = [
    # https://github.com/fredrik-johansson/arb/pull/210, included in next release
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/fredrik-johansson/arb/pull/210.patch";
      name = "return-exact-zero-where-possible.patch";
      sha256 = "01j9npnpmwh4dla9i05qdn606hy34gy9bz7c9bbsqm7az3n7pxjg";
    })
  ];
  meta = {
    inherit version;
    description = ''A library for arbitrary-precision interval arithmetic'';
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
