{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "libjpeg-6b";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/jpegsrc.v6b.tar.gz;
    md5 = "dbd5f3b47ed13132f04c685d608a7547";
  };
}
