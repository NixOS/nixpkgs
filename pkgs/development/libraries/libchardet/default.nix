{ stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation rec {
  name = "libchardet-${version}";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "Joungkyun";
    repo = "libchardet";
    rev = version;
    sha256 = "0c1k5hf3ssh3cm72w2zpy5k73vhy1gyq5s9rqdawqqa4al8syyvn";
  };

  nativeBuildInputs = [ perl ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Mozilla's Universal Charset Detector C/C++ API";
    homepage = ftp://ftp.oops.org/pub/oops/libchardet/index.html;
    license = licenses.mpl11;
    maintainers = [ maintainers.abbradar ];
    platforms = platforms.unix;
  };
}
