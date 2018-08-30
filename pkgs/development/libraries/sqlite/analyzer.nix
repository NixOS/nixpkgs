{ stdenv, fetchurl, unzip, sqlite, tcl }:

let
  archiveVersion = import ./archive-version.nix stdenv.lib;
in

stdenv.mkDerivation rec {
  name = "sqlite-analyzer-${version}";
  version = "3.24.0";

  src = assert version == sqlite.version; fetchurl {
    url = "https://sqlite.org/2018/sqlite-src-${archiveVersion version}.zip";
    sha256 = "19ck2sg13i6ga5vapxak42jn6050vpfid0zrmah7jh32mksh58vj";
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
