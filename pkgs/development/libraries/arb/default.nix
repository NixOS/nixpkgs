{stdenv, fetchFromGitHub, mpir, gmp, mpfr, flint}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "arb";
  version = "2.8.1";
  src = fetchFromGitHub {
    owner = "fredrik-johansson";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "15phk71ci9rr32aqznpkd2b993wjahsgliilkg4mnxsr86nwdf6x";
  };
  buildInputs = [mpir gmp mpfr flint];
  configureFlags = "--with-gmp=${gmp} --with-mpir=${mpir} --with-mpfr=${mpfr} --with-flint=${flint}";
  meta = {
    inherit version;
    description = ''A library for arbitrary-precision interval arithmetic'';
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
