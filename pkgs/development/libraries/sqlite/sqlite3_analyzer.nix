{ lib, stdenv, fetchurl, unzip, tcl }:

stdenv.mkDerivation {
  name = "sqlite3_analyzer-3.23.1";

  src = fetchurl {
    url = https://sqlite.org/2018/sqlite-src-3230100.zip;
    sha256 = "1z3xr8d8ds4l8ndkg34cii13d0w790nlxdkrw6virinqi7wmmd1d";
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
