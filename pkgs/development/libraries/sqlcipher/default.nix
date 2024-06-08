{ lib
, stdenv
, fetchFromGitHub
, openssl
, tcl
, installShellFiles
, buildPackages
, readline
, ncurses
, zlib
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "sqlcipher";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "sqlcipher";
    repo = "sqlcipher";
    rev = "v${version}";
    hash = "sha256-ds+0ckQiHikNMr4Xf/wCWwQySpadGgnccENd6u6gIzQ=";
  };

  nativeBuildInputs = [
    installShellFiles
    tcl
  ];

  buildInputs = [
    readline
    ncurses
    openssl
    zlib
  ];

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  configureFlags = [
    "--enable-threadsafe"
    "--with-readline-inc=-I${lib.getDev readline}/include"
  ];

  CFLAGS = [
    # We want feature parity with sqlite
    sqlite.NIX_CFLAGS_COMPILE
    "-DSQLITE_HAS_CODEC"
  ];

  BUILD_CC = "$(CC_FOR_BUILD)";

  TCLLIBDIR = "${placeholder "out"}/lib/tcl${lib.versions.majorMinor tcl.version}";

  postInstall = ''
    installManPage sqlcipher.1
  '';

  meta = with lib; {
    changelog = "https://github.com/sqlcipher/sqlcipher/blob/v${version}/CHANGELOG.md";
    description = "SQLite extension that provides 256 bit AES encryption of database files";
    mainProgram = "sqlcipher";
    homepage = "https://www.zetetic.net/sqlcipher/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
