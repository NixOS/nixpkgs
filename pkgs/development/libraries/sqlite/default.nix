{ stdenv, fetchurl, readline ? null, ncurses ? null }:

assert readline != null -> ncurses != null;

stdenv.mkDerivation {
  name = "sqlite-3.7.2";

  src = fetchurl {
    url = "http://www.sqlite.org/sqlite-amalgamation-3.7.2.tar.gz";
    sha256 = "12i50bypcq7havphrilzi0hnwgv01drxsc36kyby76hpk417zsvl";
  };

  buildInputs = [ readline ncurses ];
  
  configureFlags = "--enable-threadsafe";

  NIX_CFLAGS_COMPILE = "-DSQLITE_ENABLE_COLUMN_METADATA=1";
  NIX_CFLAGS_LINK = if readline != null then "-lncurses" else "";

  meta = {
    homepage = http://www.sqlite.org/;
    description = "A self-contained, serverless, zero-configuration, transactional SQL database engine";
  };
}
