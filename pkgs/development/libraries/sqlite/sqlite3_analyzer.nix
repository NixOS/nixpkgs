{ lib, stdenv, fetchurl, unzip, tcl }:

stdenv.mkDerivation {
  name = "sqlite3_analyzer-3.19.2";

  src = fetchurl {
    url = "https://www.sqlite.org/2017/sqlite-src-3190200.zip";
    sha256 = "1hdbs41mdyyy641gix87pllsd29p8dim7gj4qvmiyfra2q5kg749";
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
