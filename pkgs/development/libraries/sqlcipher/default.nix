{ stdenv, lib, fetchFromGitHub, openssl, tcl, readline ? null, ncurses ? null }:

assert readline != null -> ncurses != null;

stdenv.mkDerivation rec {
  name = "sqlcipher-${version}";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "sqlcipher";
    repo = "sqlcipher";
    rev = "v${version}";
    sha256 = "1lwc2m21sax3pnjfqddldbpbwr3b51s91fxz7dd7hf6ly8swnsvp";
  };

  buildInputs = [ readline ncurses openssl tcl ];

  configureFlags = [ "--enable-threadsafe" "--disable-tcl" ];

  CFLAGS = [ "-DSQLITE_ENABLE_COLUMN_METADATA=1" "-DSQLITE_SECURE_DELETE=1" "-DSQLITE_ENABLE_UNLOCK_NOTIFY=1" "-DSQLITE_HAS_CODEC" ];
  LDFLAGS = lib.optional (readline != null) "-lncurses";

  meta = with stdenv.lib; {
    homepage = http://sqlcipher.net/;
    description = "Full Database Encryption for SQLite";
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
