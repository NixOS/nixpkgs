{ lib, stdenv, fetchMavenArtifact }:

stdenv.mkDerivation rec {
  pname = "liquibase-redshift-extension";
  version = "4.8.0";

  src = fetchMavenArtifact {
    artifactId = "liquibase-redshift";
    groupId = "org.liquibase.ext";
    sha256 = "sha256-jZdDKAC4Cvmkih8VH84Z3Q8BzsqGO55Uefr8vOlbDAk=";
    inherit version;
  };

  installPhase = ''
    runHook preInstall
    install -m444 -D $src/share/java/liquibase-redshift-${version}.jar $out/share/java/liquibase-redshift.jar
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/liquibase/liquibase-redshift/";
    description = "Amazon Redshift extension for Liquibase";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sir4ur0n ];
  };
}
