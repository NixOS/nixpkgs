{stdenv, fetchurl, cxxSupport ? true, compat185 ? true}:

stdenv.mkDerivation {
  name = "db4-4.2.52";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/db-4.2.52.tar.gz;
    md5 = "cbc77517c9278cdb47613ce8cb55779f";
  };
  configureFlags = [
    (if cxxSupport then "--enable-cxx" else "--disable-cxx")
    (if cxxSupport then "--enable-compat185" else "--disable-compat185")
  ];
}
