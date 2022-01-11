{ stdenv, lib, fetchFromGitHub, openssl, tcl, installShellFiles, buildPackages, readline, ncurses, zlib }:

stdenv.mkDerivation rec {
  pname = "sqlcipher";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "sqlcipher";
    repo = "sqlcipher";
    rev = "v${version}";
    sha256 = "sha256-MFuFyKvOOrDrq9cDPQlNK6/YHSkaRX4qbw/44m5CRh4=";
  };

  nativeBuildInputs = [ installShellFiles tcl ];
  buildInputs = [ readline ncurses openssl zlib ];
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  configureFlags = [
    "--enable-threadsafe"
    "--with-readline-inc=-I${lib.getDev readline}/include"
  ];

  CFLAGS = [
    "-DSQLITE_ENABLE_COLUMN_METADATA=1"
    "-DSQLITE_SECURE_DELETE=1"
    "-DSQLITE_ENABLE_UNLOCK_NOTIFY=1"
    "-DSQLITE_HAS_CODEC"
  ];

  BUILD_CC = "$(CC_FOR_BUILD)";

  TCLLIBDIR = "${placeholder "out"}/lib/tcl${lib.versions.majorMinor tcl.version}";

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
