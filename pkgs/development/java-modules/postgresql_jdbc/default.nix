{ lib, stdenv, fetchMavenArtifact }:

stdenv.mkDerivation rec {
  pname = "postgresql-jdbc";
  version = "42.5.1";

  src = fetchMavenArtifact {
    artifactId = "postgresql";
    groupId = "org.postgresql";
    sha256 = "sha256-iei/+os3uUh5RgEsaQzwTzEDlTBRwcGT2I7ja2jTZa4=";
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
