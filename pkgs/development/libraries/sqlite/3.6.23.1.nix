{ stdenv, fetchurl, readline ? null, ncurses ? null }:

assert readline != null -> ncurses != null;

stdenv.mkDerivation {
  name = "sqlite-3.6.23.1";

  src = fetchurl {
    url = "http://www.sqlite.org/sqlite-amalgamation-3.6.23.1.tar.gz";
    sha256 = "0n1maahlqxk7p6kmsv0v2afy6qbv15n85mgkr4ylbf3ghcjdg06h";
  };

  buildInputs = [readline ncurses];
  configureFlags = "--enable-threadsafe";

  NIX_CFLAGS_COMPILE = "-DSQLITE_ENABLE_COLUMN_METADATA=1";
  NIX_CFLAGS_LINK = if readline != null then "-lncurses" else "";

  meta = {
    homepage = http://www.sqlite.org/;
    description = "A self-contained, serverless, zero-configuration, transactional SQL database engine";
  };
}
