{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "libchardet-1.0.4";
  
  src = fetchurl {
    url = "ftp://ftp.oops.org/pub/oops/libchardet/${name}.tar.bz2";
    sha256 = "0cvwba4la25qw70ap8jd5r743a9jshqd26nnbh5ph68zj1imlgzl";
  };

  nativeBuildInputs = [ perl ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Mozilla's Universal Charset Detector C/C++ API";
    homepage = ftp://ftp.oops.org/pub/oops/libchardet/index.html;
    license = licenses.mpl11;
    maintainers = [ maintainers.abbradar ];
  };
}
