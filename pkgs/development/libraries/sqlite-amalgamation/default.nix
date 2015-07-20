{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "sqlite-amalgamation-201505302257";

  src = fetchurl {
    url = "https://www.sqlite.org/snapshot/sqlite-amalgamation-201505302257.zip";
    sha256 = "0488wjrpnxd61g7pcka6fckx0q8yl1k26i6q5hrmkm92qcpml76h";
  };

  phases = [ "unpackPhase" "buildPhase" ];

  buildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  buildPhase = ''
    mkdir -p $out
    cp sqlite3.c $out/
    cp sqlite3.h $out/
    cp sqlite3ext.h $out/
    cp shell.c $out/
  '';

  meta = {
    homepage = http://www.sqlite.org/;
    description = "A single C code file, named sqlite3.c, that contains all C code for the core SQLite library and the FTS3 and RTREE extensions";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ lib.maintainers.lassulus ];
  };
}
