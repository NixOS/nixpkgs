{ lib, stdenv, fetchurl, unzip, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "hsqldb";
  version = "2.7.3";
  underscoreMajMin = lib.replaceStrings ["."] ["_"] (lib.versions.majorMinor version);

  src = fetchurl {
    url = "mirror://sourceforge/project/hsqldb/hsqldb/hsqldb_${underscoreMajMin}/hsqldb-${version}.zip";
    sha256 = "sha256-0+3uhZ9/xYI34QiGSnFzPv9WE9ktxlUI36M1vAxbHpQ=";
  };

  nativeBuildInputs = [ unzip makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/bin
    cp -R hsqldb/lib/*.jar $out/lib

    makeWrapper ${jre}/bin/java $out/bin/hsqldb --add-flags "-classpath $out/lib/hsqldb.jar org.hsqldb.server.Server"
    makeWrapper ${jre}/bin/java $out/bin/runServer --add-flags "-classpath $out/lib/hsqldb.jar org.hsqldb.server.Server"
    makeWrapper ${jre}/bin/java $out/bin/runManagerSwing --add-flags "-classpath $out/lib/hsqldb.jar org.hsqldb.util.DatabaseManagerSwing"
    makeWrapper ${jre}/bin/java $out/bin/runWebServer --add-flags "-classpath $out/lib/hsqldb.jar org.hsqldb.server.WebServer"
    makeWrapper ${jre}/bin/java $out/bin/runManager --add-flags "-classpath $out/lib/hsqldb.jar org.hsqldb.util.DatabaseManager"
    makeWrapper ${jre}/bin/java $out/bin/sqltool --add-flags "-jar $out/lib/sqltool.jar"

   runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://hsqldb.org";
    description = "Relational, embedable database management system written in Java and a set of related tools";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
