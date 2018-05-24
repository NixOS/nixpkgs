{ stdenv, tcl, sqlite }:

stdenv.mkDerivation rec {
  name = "sqlite-analyzer-${version}";
  inherit (sqlite) src version;

  nativeBuildInputs = [ tcl ];
  makeFlags = [ "sqlite3_analyzer" ];
  installPhase = "install -Dt $out/bin sqlite3_analyzer";

  meta = with stdenv.lib; {
    description = "A tool that shows statistics about SQLite databases";
    downloadPage = http://sqlite.org/download.html;
    homepage = http://www.sqlite.org;
    maintainers = with maintainers; [ pesterhazy ];
    platforms = platforms.unix;
  };
}
