{ stdenv, fetchurl, unzip, sqlite, tcl }:

let
  archiveVersion = import ./archive-version.nix stdenv.lib;
in

stdenv.mkDerivation rec {
  name = "sqlite-analyzer-${version}";
  version = "3.25.3";

  src = assert version == sqlite.version; fetchurl {
    url = "https://sqlite.org/2018/sqlite-src-${archiveVersion version}.zip";
    sha256 = "08b4fs9mrah5gxl1865smlqs2ba6g7k7d6pfa084i6d78342p4n7";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [ tcl ];

  makeFlags = [ "sqlite3_analyzer" ];

  installPhase = "install -Dt $out/bin sqlite3_analyzer";

  meta = with stdenv.lib; {
    description = "A tool that shows statistics about SQLite databases";
    downloadPage = http://sqlite.org/download.html;
    homepage = http://www.sqlite.org;
    license = licenses.publicDomain;
    maintainers = with maintainers; [ pesterhazy ];
    platforms = platforms.unix;
  };
}
