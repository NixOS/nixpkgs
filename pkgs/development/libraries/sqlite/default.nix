{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "sqlite-3.3.13";
  src = fetchurl {
    url = http://www.sqlite.org/sqlite-3.3.13.tar.gz;
    sha256 = "0p32asxkb38g6mbb2p7hdk09bnrrqn67dgnvgqx7pvwi5vcl80ck";
  };
  configureFlags = "--enable-threadsafe --disable-tcl";
}
