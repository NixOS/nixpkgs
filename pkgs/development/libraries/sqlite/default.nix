{ lib, stdenv, fetchurl, interactive ? false, readline ? null, ncurses ? null }:

assert interactive -> readline != null && ncurses != null;

stdenv.mkDerivation {
  name = "sqlite-3.8.9";

  src = fetchurl {
    url = "http://sqlite.org/2015/sqlite-autoconf-3080900.tar.gz";
    sha1 = "p6vwiqalhk7ybcx5p8n322vhd3idww6v";
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
