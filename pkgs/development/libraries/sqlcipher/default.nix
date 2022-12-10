{ stdenv, lib, fetchFromGitHub, openssl, tcl, installShellFiles, buildPackages, readline, ncurses, zlib, sqlite }:

stdenv.mkDerivation rec {
  pname = "sqlcipher";
  version = "4.5.2";

  src = fetchFromGitHub {
    owner = "sqlcipher";
    repo = "sqlcipher";
    rev = "v${version}";
    sha256 = "sha256-EUm4akVWUiK8U6Je1uWMo8KLQLsk57kOFCCU5Uajjt8=";
  };

  nativeBuildInputs = [ installShellFiles tcl ];
  buildInputs = [ readline ncurses openssl zlib ];
  depsBuildBuild = [ buildPackages.stdenv.cc ];

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
    homepage = "https://www.zetetic.net/sqlcipher/";
    description = "SQLite extension that provides 256 bit AES encryption of database files";
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
