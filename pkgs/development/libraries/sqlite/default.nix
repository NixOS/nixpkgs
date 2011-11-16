{ stdenv, fetchurl, readline ? null, ncurses ? null }:

assert readline != null -> ncurses != null;

stdenv.mkDerivation {
  name = "sqlite-3.7.9";

  src = fetchurl {
    url = http://www.sqlite.org/sqlite-autoconf-3070900.tar.gz;
    sha1 = "a9da98a4bde4d9dae5c29a969455d11a03600e11";
  };

  buildInputs = [ readline ncurses ];
  
  configureFlags = "--enable-threadsafe";

  CFLAGS = "-DSQLITE_ENABLE_COLUMN_METADATA=1 -DSQLITE_SECURE_DELETE=1 -DSQLITE_ENABLE_UNLOCK_NOTIFY=1";
  LDFLAGS = if readline != null then "-lncurses" else "";

  meta = {
    homepage = http://www.sqlite.org/;
    description = "A self-contained, serverless, zero-configuration, transactional SQL database engine";
  };
}
