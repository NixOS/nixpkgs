{ stdenv, fetchurl, unzip, sqlite, tcl }:

let
  archiveVersion = import ./archive-version.nix stdenv.lib;
in

stdenv.mkDerivation rec {
  pname = "sqlite-analyzer";
  version = "3.33.0";

  src = assert version == sqlite.version; fetchurl {
    url = "https://sqlite.org/2020/sqlite-src-${archiveVersion version}.zip";
    sha256 = "1f09srlrmcab1sf8j2d89s2kvknlbxk7mbsiwpndw9mall27dgwh";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [ tcl ];

  makeFlags = [ "sqlite3_analyzer" ];

  installPhase = "install -Dt $out/bin sqlite3_analyzer";

  meta = with stdenv.lib; {
    description = "A tool that shows statistics about SQLite databases";
    downloadPage = "http://sqlite.org/download.html";
    homepage = "https://www.sqlite.org";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ pesterhazy ];
    platforms = platforms.unix;
  };
}
