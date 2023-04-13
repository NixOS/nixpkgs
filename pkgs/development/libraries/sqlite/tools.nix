{ lib, stdenv, fetchurl, unzip, sqlite, tcl, Foundation }:

let
  archiveVersion = import ./archive-version.nix lib;
  mkTool = { pname, makeTarget, description, homepage, mainProgram }: stdenv.mkDerivation rec {
    inherit pname;
    version = "3.41.2";

    # nixpkgs-update: no auto update
    src = assert version == sqlite.version; fetchurl {
      url = "https://sqlite.org/2023/sqlite-src-${archiveVersion version}.zip";
      hash = "sha256-hxkfzsuLcH2aEO2xNgdoYxfXFpwIC5vcXTnQY1g3bMw=";
    };

    nativeBuildInputs = [ unzip ];
    buildInputs = [ tcl ] ++ lib.optional stdenv.isDarwin Foundation;

    makeFlags = [ makeTarget ];

    installPhase = "install -Dt $out/bin ${makeTarget}";

    meta = with lib; {
      inherit description homepage mainProgram;
      downloadPage = "http://sqlite.org/download.html";
      license = licenses.publicDomain;
      maintainers = with maintainers; [ johnazoidberg ];
      platforms = platforms.unix;
    };
  };
in
{
  sqldiff = mkTool {
    pname = "sqldiff";
    makeTarget = "sqldiff";
    description = "A tool that displays the differences between SQLite databases";
    homepage = "https://www.sqlite.org/sqldiff.html";
    mainProgram = "sqldiff";
  };
  sqlite-analyzer = mkTool {
    pname = "sqlite-analyzer";
    makeTarget = "sqlite3_analyzer";
    description = "A tool that shows statistics about SQLite databases";
    homepage = "https://www.sqlite.org/sqlanalyze.html";
    mainProgram = "sqlite3_analyzer";
  };
}
