{ lib, stdenv, fetchurl, unzip, sqlite, tcl, Foundation }:

let
  archiveVersion = import ./archive-version.nix lib;
  mkTool = { pname, makeTarget, description, homepage }: stdenv.mkDerivation rec {
    inherit pname;
    version = "3.36.0";

    src = assert version == sqlite.version; fetchurl {
      url = "https://sqlite.org/2021/sqlite-src-${archiveVersion version}.zip";
      sha256 = "092khwfm0m0i80sjb4fc5569jj0kilm6pa867w0akcv6h38bk8r5";
    };

    nativeBuildInputs = [ unzip ];
    buildInputs = [ tcl ] ++ lib.optional stdenv.isDarwin Foundation;

    makeFlags = [ makeTarget ];

    installPhase = "install -Dt $out/bin ${makeTarget}";

    meta = with lib; {
      inherit description homepage;
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
  };
  sqlite-analyzer = mkTool {
    pname = "sqlite-analyzer";
    makeTarget = "sqlite3_analyzer";
    description = "A tool that shows statistics about SQLite databases";
    homepage = "https://www.sqlite.org/sqlanalyze.html";
  };
}
