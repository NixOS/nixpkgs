{ lib, stdenv, fetchurl, unzip, tcl }:

stdenv.mkDerivation {
  name = "sqlite3_analyzer-3.17.0";

  src = fetchurl {
    url = "https://www.sqlite.org/2017/sqlite-src-3170000.zip";
    sha256 = "1hs8nzk2pjr4fhhrwcyqwpa24gd4ndp6f0japykg5wfadgp4nxc6";
  };

  buildInputs = [ unzip tcl ];

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
