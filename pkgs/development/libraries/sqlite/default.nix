{ stdenv, fetchurl, readline ? null, ncurses ? null }:

assert readline != null -> ncurses != null;

stdenv.mkDerivation {
  name = "sqlite-3.8.4.3";

  src = fetchurl {
    url = "http://www.sqlite.org/2014/sqlite-autoconf-3080403.tar.gz";
    sha1 = "zd9nqg1fc41222hvzvmvzr92z80b3wvh";
  };

  buildInputs = [ readline ncurses ];

  configureFlags = "--enable-threadsafe";

  CFLAGS = "-DSQLITE_ENABLE_COLUMN_METADATA=1 -DSQLITE_SECURE_DELETE=1 -DSQLITE_ENABLE_UNLOCK_NOTIFY=1";
  LDFLAGS = if readline != null then "-lncurses" else "";

  meta = {
    homepage = http://www.sqlite.org/;
    description = "A self-contained, serverless, zero-configuration, transactional SQL database engine";
    platforms = stdenv.lib.platforms.unix;
  };
}
