{ stdenv, fetchurl, readline ? null, ncurses ? null }:

assert readline != null -> ncurses != null;

stdenv.mkDerivation {
  name = "sqlite-3.7.7.1";

  src = fetchurl {
    url = http://www.sqlite.org/sqlite-autoconf-3070701.tar.gz;
    sha256 = "1pvf72gb6yidc4zjml3k6kwhlvvhbgmbm8hfin9y5jvvbyr3dk3x";
  };

  buildInputs = [ readline ncurses ];
  
  configureFlags = "--enable-threadsafe";

  NIX_CFLAGS_COMPILE = "-DSQLITE_ENABLE_COLUMN_METADATA=1 -DSQLITE_SECURE_DELETE=1 -DSQLITE_SECURE_DELETE=1";
  NIX_CFLAGS_LINK = if readline != null then "-lncurses" else "";

  meta = {
    homepage = http://www.sqlite.org/;
    description = "A self-contained, serverless, zero-configuration, transactional SQL database engine";
  };
}
