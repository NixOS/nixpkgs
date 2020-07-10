{ stdenv, lib, fetchFromGitHub, openssl, tcl, installShellFiles, readline ? null, ncurses ? null }:

assert readline != null -> ncurses != null;

stdenv.mkDerivation rec {
  pname = "sqlcipher";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "sqlcipher";
    repo = "sqlcipher";
    rev = "v${version}";
    sha256 = "0mx0n5n3s39r25b31sdkrd4psxjqqgcv6rpm9d57w5rlk75g2fiv";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ readline ncurses openssl tcl ];

  configureFlags = [ "--enable-threadsafe" "--disable-tcl" ];

  CFLAGS = [ "-DSQLITE_ENABLE_COLUMN_METADATA=1" "-DSQLITE_SECURE_DELETE=1" "-DSQLITE_ENABLE_UNLOCK_NOTIFY=1" "-DSQLITE_HAS_CODEC" ];
  LDFLAGS = lib.optional (readline != null) "-lncurses";

  doCheck = false; # fails. requires tcl?

  postInstall = ''
    installManPage sqlcipher.1
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.zetetic.net/sqlcipher/";
    description = "SQLite extension that provides 256 bit AES encryption of database files";
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
