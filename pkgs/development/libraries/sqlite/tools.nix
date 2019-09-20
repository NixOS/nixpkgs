{ stdenv, fetchurl, unzip, sqlite, tcl, Foundation }:

let
  archiveVersion = import ./archive-version.nix stdenv.lib;
  mkTool = { pname, makeTarget, description, homepage }: stdenv.mkDerivation rec {
    inherit pname;
    version = "3.28.0";

    src = assert version == sqlite.version; fetchurl {
      url = "https://sqlite.org/2019/sqlite-src-${archiveVersion version}.zip";
      sha256 = "15v57b113bpgcshfsx5jw93szar3da94rr03i053xhl15la7jllh";
    };

    nativeBuildInputs = [ unzip ];
    buildInputs = [ tcl ] ++ stdenv.lib.optional stdenv.isDarwin Foundation;

    makeFlags = [ makeTarget ];

    installPhase = "install -Dt $out/bin ${makeTarget}";

    meta = with stdenv.lib; {
      inherit description homepage;
      downloadPage = http://sqlite.org/download.html;
      license = licenses.publicDomain;
      maintainers = with maintainers; [ pesterhazy johnazoidberg ];
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
