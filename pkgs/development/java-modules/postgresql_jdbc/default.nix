{ lib, stdenv, fetchMavenArtifact }:

stdenv.mkDerivation rec {
  pname = "postgresql-jdbc";
  version = "42.2.20";

  src = fetchMavenArtifact {
    artifactId = "postgresql";
    groupId = "org.postgresql";
    sha256 = "0kjilsrz9shymfki48kg1q84la1870ixlh2lnfw347x8mqw2k2vh";
    inherit version;
  };

  installPhase = ''
    runHook preInstall
    install -m444 -D $src/share/java/*postgresql-${version}.jar $out/share/java/postgresql-jdbc.jar
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://jdbc.postgresql.org/";
    description = "JDBC driver for PostgreSQL allowing Java programs to connect to a PostgreSQL database";
    license = licenses.bsd2;
    platforms = platforms.unix;
  };
}
