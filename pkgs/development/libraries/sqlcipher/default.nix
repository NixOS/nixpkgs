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
<<<<<<< HEAD
  version = "4.5.5";
=======
  version = "4.5.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sqlcipher";
    repo = "sqlcipher";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-amWYkVQr+Rmcj+32lFDRq43Q+Ojj8V8B6KoURqdwGt0=";
=======
    hash = "sha256-n9KPtTj/mHXrnFJnbWPO3H+Vol3Z2mg7XLl55ynyLwY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    homepage = "https://www.zetetic.net/sqlcipher/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
