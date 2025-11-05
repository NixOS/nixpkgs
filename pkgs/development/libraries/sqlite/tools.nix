{
  lib,
  stdenv,
  fetchurl,
  unzip,
  sqlite,
  tcl,
}:

let
  archiveVersion = import ./archive-version.nix lib;
  mkTool =
    {
      pname,
      makeTarget,
      description,
      homepage,
      mainProgram,
    }:
    stdenv.mkDerivation rec {
      inherit pname;
      version = "3.51.1";

      # nixpkgs-update: no auto update
      src =
        assert version == sqlite.version;
        fetchurl {
          url = "https://sqlite.org/2025/sqlite-src-${archiveVersion version}.zip";
          hash = "sha256-D452WsjqfDbPjqm//dXBA1ZPSopjXyFfn3g7M4oT2XE=";
        };

      nativeBuildInputs = [ unzip ];
      buildInputs = [ tcl ];

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
