{ lib, stdenv, fetchurl, unzip, sqlite, tcl, Foundation }:

let
  archiveVersion = import ./archive-version.nix lib;
  mkTool = { pname, makeTarget, description, homepage, mainProgram }: stdenv.mkDerivation rec {
    inherit pname;
    version = "3.47.0";

    # nixpkgs-update: no auto update
    src = assert version == sqlite.version; fetchurl {
      url = "https://sqlite.org/2024/sqlite-src-${archiveVersion version}.zip";
      hash = "sha256-9Zw0m+20cCA1hqa20QrbNfKv76SfkeVaZyo2oJqP7fc=";
    };

    nativeBuildInputs = [ unzip ];
    buildInputs = [ tcl ] ++ lib.optional stdenv.hostPlatform.isDarwin Foundation;

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
    description = "Tool that displays the differences between SQLite databases";
    homepage = "https://www.sqlite.org/sqldiff.html";
    mainProgram = "sqldiff";
  };
  sqlite-analyzer = mkTool {
    pname = "sqlite-analyzer";
    makeTarget = "sqlite3_analyzer";
    description = "Tool that shows statistics about SQLite databases";
    homepage = "https://www.sqlite.org/sqlanalyze.html";
    mainProgram = "sqlite3_analyzer";
  };
  sqlite-rsync = mkTool {
    pname = "sqlite-rsync";
    makeTarget = "sqlite3_rsync";
    description = "Database remote-copy tool for SQLite";
    homepage = "https://www.sqlite.org/rsync.html";
    mainProgram = "sqlite3_rsync";
  };
}
