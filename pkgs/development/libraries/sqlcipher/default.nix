{ stdenv, lib, fetchFromGitHub, openssl, tcl, installShellFiles, buildPackages, readline ? null, ncurses ? null }:

assert readline != null -> ncurses != null;

stdenv.mkDerivation rec {
  pname = "sqlcipher";
  version = "4.4.3";

  src = fetchFromGitHub {
    owner = "sqlcipher";
    repo = "sqlcipher";
    rev = "v${version}";
    sha256 = "sha256-E23PTNnVZbBQtHL0YjUwHNVUA76XS8rlARBOVvX6zZw=";
  };

  nativeBuildInputs = [ installShellFiles tcl ];
  buildInputs = [ readline ncurses openssl ];
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  configureFlags = [ "--enable-threadsafe" "--disable-tcl" ];

  CFLAGS = [ "-DSQLITE_ENABLE_COLUMN_METADATA=1" "-DSQLITE_SECURE_DELETE=1" "-DSQLITE_ENABLE_UNLOCK_NOTIFY=1" "-DSQLITE_HAS_CODEC" ];
  LDFLAGS = lib.optional (readline != null) "-lncurses";
  BUILD_CC = "$(CC_FOR_BUILD)";

  doCheck = false; # fails. requires tcl?

  postInstall = ''
    installManPage sqlcipher.1
  '';

  meta = with lib; {
    homepage = "https://www.zetetic.net/sqlcipher/";
    description = "SQLite extension that provides 256 bit AES encryption of database files";
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
