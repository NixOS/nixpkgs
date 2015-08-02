{ lib, stdenv, fetchurl, interactive ? false, readline ? null, ncurses ? null }:

assert interactive -> readline != null && ncurses != null;

stdenv.mkDerivation {
  name = "sqlite-3.8.11.1";

  src = fetchurl {
    url = "http://sqlite.org/2015/sqlite-autoconf-3081101.tar.gz";
    sha1 = "d0e22d7e361b6f50830a3cdeafe35311443f8f9a";
  };

  buildInputs = lib.optionals interactive [ readline ncurses ];

  configureFlags = "--enable-threadsafe";

  NIX_CFLAGS_COMPILE = "-DSQLITE_ENABLE_COLUMN_METADATA=1 -DSQLITE_SECURE_DELETE=1 -DSQLITE_ENABLE_UNLOCK_NOTIFY=1";

  meta = {
    homepage = http://www.sqlite.org/;
    description = "A self-contained, serverless, zero-configuration, transactional SQL database engine";
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ eelco np ];
  };
}
