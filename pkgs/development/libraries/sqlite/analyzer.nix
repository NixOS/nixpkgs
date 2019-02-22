{ stdenv, fetchurl, unzip, sqlite, tcl }:

let
  archiveVersion = import ./archive-version.nix stdenv.lib;
in

stdenv.mkDerivation rec {
  name = "sqlite-analyzer-${version}";
  version = "3.27.1";

  src = assert version == sqlite.version; fetchurl {
    url = "https://sqlite.org/2019/sqlite-src-${archiveVersion version}.zip";
    sha256 = "11jrr14ld9cs9l5pz3z83xds1mhsqwgg47vwdx8rq6p667dc9z7h";
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
