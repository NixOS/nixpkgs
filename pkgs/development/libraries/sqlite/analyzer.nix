{ stdenv, fetchurl, unzip, sqlite, tcl }:

let
  archiveVersion = import ./archive-version.nix stdenv.lib;
in

stdenv.mkDerivation rec {
  name = "sqlite-analyzer-${version}";
  version = "3.23.1";

  src = assert version == sqlite.version; fetchurl {
    url = "https://sqlite.org/2018/sqlite-src-${archiveVersion version}.zip";
    sha256 = "1z3xr8d8ds4l8ndkg34cii13d0w790nlxdkrw6virinqi7wmmd1d";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [ tcl ];

  makeFlags = [ "sqlite3_analyzer" ];

  installPhase = "install -Dt $out/bin sqlite3_analyzer";

  meta = with stdenv.lib; {
    description = "A tool that shows statistics about SQLite databases";
    downloadPage = http://sqlite.org/download.html;
    homepage = http://www.sqlite.org;
    maintainers = with maintainers; [ pesterhazy ];
    platforms = platforms.unix;
  };
}
