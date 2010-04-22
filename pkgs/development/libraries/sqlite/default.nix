{ stdenv, fetchurl, readline ? null, ncurses ? null }:

assert readline != null -> ncurses != null;

stdenv.mkDerivation {
  name = "sqlite-3.6.23";

  src = fetchurl {
    url = "http://www.sqlite.org/sqlite-amalgamation-3.6.23.tar.gz";
    sha256 = "a5de9ec9273acabc6cb18235df802549c476410b09d58a206e02862b4dc303ae";
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
