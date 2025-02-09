{ lib, stdenv, fetchMavenArtifact }:

stdenv.mkDerivation rec {
  pname = "postgresql-jdbc";
  version = "42.6.0";

  src = fetchMavenArtifact {
    artifactId = "postgresql";
    groupId = "org.postgresql";
    hash = "sha256-uBfGekDJQkn9WdTmhuMyftDT0/rkJrINoPHnVlLPxGE=";
    inherit version;
  };

  installPhase = ''
    runHook preInstall
    install -m444 -D $src/share/java/*postgresql-${version}.jar $out/share/java/postgresql-jdbc.jar
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://jdbc.postgresql.org/";
    changelog = "https://github.com/pgjdbc/pgjdbc/releases/tag/REL${version}";
    description = "JDBC driver for PostgreSQL allowing Java programs to connect to a PostgreSQL database";
    license = licenses.bsd2;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.unix;
  };
}
