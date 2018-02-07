{ lib, stdenv, fetchurl, unzip, tcl }:

stdenv.mkDerivation {
  name = "sqlite3_analyzer-3.20.1";

  src = fetchurl {
    url = "https://www.sqlite.org/2017/sqlite-src-3200100.zip";
    sha256 = "0aicmapa99141hjncyxwg66ndhr16nwpbqy27x79fg1ikzhwlnv6";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [ tcl ];

  makeFlags = [ "sqlite3_analyzer" ];

  installPhase = ''
    install -Dm755 sqlite3_analyzer \
      "$out/bin/sqlite3_analyzer"
  '';

  meta = with stdenv.lib; {
    homepage = http://www.sqlite.org/;
    description = "A tool that shows statistics about sqlite databases";
    platforms = platforms.unix;
    maintainers = with maintainers; [ pesterhazy ];
  };
}
