{ stdenv, fetchurl, readline ? null, ncurses ? null }:

assert readline != null -> ncurses != null;

stdenv.mkDerivation {
  name = "sqlite-3.7.15.2";

  src = fetchurl {
    url = "http://www.sqlite.org/sqlite-autoconf-3071502.tar.gz";
    sha1 = "075732562183d560cd46a0d8d08b50bc44e34eac";
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
