{stdenv, fetchurl, libdvdcss}:

assert libdvdcss != null;

derivation {
  name = "libdvdread-20030812";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.videolan.org/pub/videolan/vlc/0.6.2/contrib/libdvdread-20030812.tar.bz2;
    md5 = "9d58beac7c2dfb98d00f4ed0ea3d7274";
  };
  stdenv = stdenv;
  libdvdcss = libdvdcss;
}
