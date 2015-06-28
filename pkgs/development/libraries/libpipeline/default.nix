{ stdenv, fetchurl }:
 
stdenv.mkDerivation rec {
  name = "libpipeline-1.4.0";
  
  src = fetchurl {
    url = "mirror://savannah/libpipeline/${name}.tar.gz";
    sha256 = "1dlvp2mxlhg5zbj509kc60h7g39hpgwkzkpdf855cyzizgkmkivr";
  };

  meta = with stdenv.lib; {
    homepage = "http://libpipeline.nongnu.org";
    description = "C library for manipulating pipelines of subprocesses in a flexible and convenient way";
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}
