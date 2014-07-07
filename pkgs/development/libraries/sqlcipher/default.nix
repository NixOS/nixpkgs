{ stdenv, fetchurl, openssl, tcl, readline ? null, ncurses ? null }:

assert readline != null -> ncurses != null;

stdenv.mkDerivation {
  name = "sqlcipher-3.1.0";

  src = fetchurl {
    url = "https://github.com/sqlcipher/sqlcipher/archive/v3.1.0.tar.gz";
    sha256 = "1h54hsl7g6ra955aaqid5wxm93fklx2pxz8abcdwf9md3bpfcn18";
  };

  buildInputs = [ readline ncurses openssl tcl ];

  configureFlags = "--enable-threadsafe --disable-tcl";

  CFLAGS = "-DSQLITE_ENABLE_COLUMN_METADATA=1 -DSQLITE_SECURE_DELETE=1 -DSQLITE_ENABLE_UNLOCK_NOTIFY=1 -DSQLITE_HAS_CODEC";
  LDFLAGS = if readline != null then "-lncurses" else "";

  meta = {
    homepage = http://sqlcipher.net/;
    description = "Full Database Encryption for SQLite";
    platforms = stdenv.lib.platforms.unix;
  };
}
