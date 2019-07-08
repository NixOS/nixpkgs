{ stdenv, fetchurl, unzip, sqlite, tcl }:

let
  archiveVersion = import ./archive-version.nix stdenv.lib;
in

stdenv.mkDerivation rec {
  name = "sqlite-analyzer-${version}";
  version = "3.28.0";

  src = assert version == sqlite.version; fetchurl {
    url = "https://sqlite.org/2019/sqlite-src-${archiveVersion version}.zip";
    sha256 = "15v57b113bpgcshfsx5jw93szar3da94rr03i053xhl15la7jllh";
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
