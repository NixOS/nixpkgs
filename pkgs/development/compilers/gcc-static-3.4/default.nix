{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "gcc-static-3.4.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/gcc-3.4.2.tar.bz2;
    md5 = "2fada3a3effd2fd791df09df1f1534b3";
  };
  # !!! apply only if noSysDirs is set
  patches = [./no-sys-dirs.patch];
  noSysDirs = 1;
}
