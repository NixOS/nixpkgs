{ lib, stdenv, fetchMavenArtifact }:

stdenv.mkDerivation rec {
  pname = "liquibase-clickhouse";
  version = "0.7.3-awake1";

  src = fetchMavenArtifact {
    artifactId = "liquibase-clickhouse";
    groupId = "com.mediarithmics";
    sha256 = "sha256-4zZjWmW2fejsX4Av/ZOfcFhDKCwJyRVM7qScvxR58CU=";
    classifier = "shaded";
    repos = [
      "https://artifactory.infra.corp.arista.io/artifactory/awake-ndr-third-party-patched/"
    ];
    inherit version;
  };

  installPhase = ''
    runHook preInstall
    install -m444 -D $src/share/java/*liquibase-clickhouse-${version}-shaded.jar $out/share/java/liquibase-clickhouse.jar
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/MEDIARITHMICS/liquibase-clickhouse";
    description = "ClickHouse driver for Liquibase";
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
