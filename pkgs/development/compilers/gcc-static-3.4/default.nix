{ stdenv, fetchurl, noSysDirs}:

stdenv.mkDerivation {
  name = "gcc-static-3.4.6";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/gcc/gcc-3.4.6/gcc-3.4.6.tar.bz2;
    md5 = "4a21ac777d4b5617283ce488b808da7b";
  };
  # !!! apply only if noSysDirs is set
  inherit noSysDirs;
  patches = if noSysDirs then [./no-sys-dirs.patch] else [./ldflags.patch];
}
