{ lib, stdenv, fetchurl, interactive ? false, readline ? null, ncurses ? null }:

assert interactive -> readline != null && ncurses != null;

stdenv.mkDerivation {
  name = "sqlite-3.8.7.4";

  src = fetchurl {
    url = "http://www.sqlite.org/2014/sqlite-autoconf-3080704.tar.gz";
    sha1 = "70ca0b8884a6b145b7f777724670566e2b4f3cde";
  };

  buildInputs = lib.optionals interactive [ readline ncurses ];

  configureFlags = "--enable-threadsafe";

  NIX_CFLAGS_COMPILE = "-DSQLITE_ENABLE_COLUMN_METADATA=1 -DSQLITE_SECURE_DELETE=1 -DSQLITE_ENABLE_UNLOCK_NOTIFY=1";

  meta = {
    homepage = http://www.sqlite.org/;
    description = "A self-contained, serverless, zero-configuration, transactional SQL database engine";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
