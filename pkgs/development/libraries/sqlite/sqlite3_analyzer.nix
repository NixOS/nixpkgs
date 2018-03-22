{ lib, stdenv, fetchurl, unzip, tcl }:

stdenv.mkDerivation {
  name = "sqlite3_analyzer-3.22.0";

  src = fetchurl {
    url = "https://www.sqlite.org/2018/sqlite-src-3220000.zip";
    sha256 = "04w97jj1659vl84rr73wg1mhj6by8r5075rzpn2xp42n537a7ibv";
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
