{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "libhangul-0.1.0";

  src = fetchurl {
    url = "https://libhangul.googlecode.com/files/libhangul-0.1.0.tar.gz";
    sha256 = "0ni9b0v70wkm0116na7ghv03pgxsfpfszhgyj3hld3bxamfal1ar";
  };

  meta = with stdenv.lib; {
    description = "Core algorithm library for Korean input routines";
    homepage = https://code.google.com/p/libhangul;
    license = licenses.lgpl21;
    maintainers = [ maintainers.ianwookim ];
    platforms = platforms.linux;
  };
}
