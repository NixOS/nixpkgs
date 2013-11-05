{ stdenv, fetchurl, readline ? null, ncurses ? null }:

assert readline != null -> ncurses != null;

stdenv.mkDerivation {
  name = "sqlite-3.8.0.2";

  src = fetchurl {
    url = http://www.sqlite.org/2013/sqlite-autoconf-3080002.tar.gz;
    sha1 = "294c30e882a0d45877bce09afe72d08ccfc6b650";
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
