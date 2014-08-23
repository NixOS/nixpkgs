{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libdvdcss-1.2.13";
  
  src = fetchurl {
    url = http://download.videolan.org/pub/libdvdcss/1.2.13/libdvdcss-1.2.13.tar.bz2;
    sha256 = "0b5s25awn2md4jr00rwg5siwvi3kivyaxkjgfxzzh7ggrykbpwc4";
  };

  meta = {
    homepage = http://www.videolan.org/developers/libdvdcss.html;
    description = "A library for decrypting DVDs";
  };
}
