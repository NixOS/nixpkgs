{ lib, stdenv, fetchurl, unzip, tcl }:

stdenv.mkDerivation {
  name = "sqlite3_analyzer-3.8.10.1";

  src = fetchurl {
    url = "https://www.sqlite.org/2015/sqlite-src-3081001.zip";
    sha1 = "6z7w8y69jxr0xwxbhs8z3zf56zfs5x7z";
  };

  buildInputs = [ unzip tcl ];

  # A bug in the latest release of sqlite3 prevents bulding sqlite3_analyzer.
  # Hopefully this work-around can be removed for future releases.
  postConfigure = ''
    substituteInPlace Makefile \
      --replace '"#define SQLITE_ENABLE_DBSTAT_VTAB"' '"#define SQLITE_ENABLE_DBSTAT_VTAB 1"'
  '';

  buildPhase = ''
    make sqlite3_analyzer
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    mv sqlite3_analyzer "$out/bin"
  '';

  meta = {
    homepage = http://www.sqlite.org/;
    description = "A tool that shows statistics about sqlite databases";
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ pesterhazy ];
  };
}
