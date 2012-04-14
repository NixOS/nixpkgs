{ stdenv, fetchurl, tcl, readline ? null, ncurses ? null }:

assert readline != null -> ncurses != null;

stdenv.mkDerivation {
  # I try to keep a version no newer than default.nix, and similar CFLAGS,
  # for this to be compatible with it.
  name = "sqlite-3.7.9-full";

  src = fetchurl {
    url = "http://www.sqlite.org/cgi/src/tarball/SQLite-3.7.9.tar.gz?uuid=version-3.7.9";
    sha256 = "0v11slxgjpx2nv7wp8c76wk2pa1dijs9v6zlcn2dj9jblp3bx8fk";
  };

  buildInputs = [ readline ncurses ];
  buildNativeInputs = [ tcl ];

  doCheck = true;
  checkTarget = "test";
  
  configureFlags = "--enable-threadsafe --enable-tempstore";

  preConfigure = ''
    export TCLLIBDIR=$out/${tcl.libdir}
  '';

  CFLAGS = "-DSQLITE_ENABLE_COLUMN_METADATA=1 -DSQLITE_SECURE_DELETE=1 -DSQLITE_ENABLE_UNLOCK_NOTIFY=1";
  LDFLAGS = if readline != null then "-lncurses" else "";

  postInstall = ''
    make sqlite3_analyzer
    cp sqlite3_analyzer $out/bin
  '';

  meta = {
    homepage = http://www.sqlite.org/;
    description = "A self-contained, serverless, zero-configuration, transactional SQL database engine";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
