{stdenv, fetchurl, libdvdcss}:

assert libdvdcss != null;

stdenv.mkDerivation {
  name = "libdvdread-20030812";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/libdvdread-20030812.tar.bz2;
    md5 = "9d58beac7c2dfb98d00f4ed0ea3d7274";
  };
  buildInputs = libdvdcss;
  inherit libdvdcss;
}
