{stdenv, fetchurl, libdvdread}:

assert libdvdread != null;

stdenv.mkDerivation {
  name = "libdvdplay-1.0.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.videolan.org/pub/libdvdplay/1.0.1/libdvdplay-1.0.1.tar.bz2;
    md5 = "602bca4ef78d79aa87e5e8920d958a78";
  };
  libdvdread = libdvdread;
}
