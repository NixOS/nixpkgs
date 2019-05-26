{ stdenv, fetchMavenArtifact }:

stdenv.mkDerivation rec {
  name = "postgresql-jdbc-${version}";
  version = "42.2.5";

  src = fetchMavenArtifact {
    artifactId = "postgresql";
    groupId = "org.postgresql";
    sha256 = "1p0cbb7ka41xxipzjy81hmcndkqynav22xyipkg7qdqrqvw4dykz";
    inherit version;
  };

  phases = [ "installPhase" ];

  installPhase = ''
    install -m444 -D $src/share/java/*postgresql-${version}.jar $out/share/java/postgresql-jdbc.jar
  '';

  meta = with stdenv.lib; {
    homepage = https://jdbc.postgresql.org/;
    description = "JDBC driver for PostgreSQL allowing Java programs to connect to a PostgreSQL database";
    license = licenses.bsd2;
    platforms = platforms.unix;
  };
}
