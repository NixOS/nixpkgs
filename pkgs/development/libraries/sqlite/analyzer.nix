{ stdenv, fetchurl, unzip, sqlite, tcl }:

let
  archiveVersion = import ./archive-version.nix stdenv.lib;
in

stdenv.mkDerivation rec {
  pname = "sqlite-analyzer";
  version = "3.29.0";

  src = assert version == sqlite.version; fetchurl {
    url = "https://sqlite.org/2019/sqlite-src-${archiveVersion version}.zip";
    sha256 = "05w89ja0h1qbcb13z0b4hmwp1p8ywy9z73yscskrr5jfa2bkslx1";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [ tcl ];

  makeFlags = [ "sqlite3_analyzer" ];

  installPhase = "install -Dt $out/bin sqlite3_analyzer";

  meta = with stdenv.lib; {
    description = "A tool that shows statistics about SQLite databases";
    downloadPage = http://sqlite.org/download.html;
    homepage = https://www.sqlite.org;
    license = licenses.publicDomain;
    maintainers = with maintainers; [ pesterhazy ];
    platforms = platforms.unix;
  };
}
