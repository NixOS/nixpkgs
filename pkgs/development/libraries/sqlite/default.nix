{ stdenv, fetchurl, readline ? null, ncurses ? null }:

assert readline != null -> ncurses != null;

stdenv.mkDerivation {
  name = "sqlite-3.7.5";

  src = fetchurl {
    url = http://www.sqlite.org/sqlite-autoconf-3070500.tar.gz;
    sha256 = "151gdb7lhzppccc42wzc27ckf0v25m7j9pfxna15ixn9ds98cnyb";
  };

  buildInputs = [ readline ncurses ];
  
  configureFlags = "--enable-threadsafe";

  NIX_CFLAGS_COMPILE = "-DSQLITE_ENABLE_COLUMN_METADATA=1";
  NIX_CFLAGS_LINK = if readline != null then "-lncurses" else "";

  meta = {
    homepage = http://www.sqlite.org/;
    description = "A self-contained, serverless, zero-configuration, transactional SQL database engine";
  };
}
