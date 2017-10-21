{ lib, stdenv, fetchurl, unzip, tcl }:

stdenv.mkDerivation {
  name = "sqlite3_analyzer-3.20.0";

  src = fetchurl {
    url = "https://www.sqlite.org/2017/sqlite-src-3200000.zip";
    sha256 = "1vjbc5i95wildrdfzalrsgai1ziz4m4gbah4wm8qc4jxm1vqwdab";
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
