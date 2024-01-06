{ lib
, stdenv
, maven
, jdk8
, fetchFromGitHub
, makeWrapper
, mvnDepsHash ? null
}:

let
  maven' = maven.override { jdk = jdk8; };

  mvnDepsHashes = {
    "x86_64-linux" = "sha256-jmlViuCuuibe7/N9MBsrCvK7pgtm2p2h/kbEpuCVhhg=";
    "aarch64-linux" = "sha256-iJVMVblv7z7rEnVxysttiPaT14VZd0YPs857h4OOdL4=";
    "x86_64-darwin" = "sha256-naP8VEU6uLBV8kfDZ5W/M7uE8CPKtWbv2XbolD4Y+8U=";
    "aarch64-darwin" = "sha256-fV60ZathIdU5hSaZJZ51UyqAhmpR4hLvSMhB4lZUh5s=";
  };
in
maven'.buildMavenPackage rec {
  pname = "tika";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "tika";
    rev = version;
    hash = "sha256-Ne6KifbCDMeJBF95NNDD9V4pCYHsDw89EQC2myfnRDo=";
  };

  buildOffline = true;

  manualMvnArtifacts = [
    "org.apache.apache.resources:apache-jar-resource-bundle:1.5"
    "org.apache.maven.surefire:surefire-junit-platform:3.1.2"
    "org.junit.platform:junit-platform-launcher:1.10.0"
  ];

  mvnHash =
    if mvnDepsHash != null then mvnDepsHash
    else mvnDepsHashes.${stdenv.system} or (lib.warn "This platform doesn't have a default mvnDepsHash value, you'll need to specify it manually" lib.fakeHash);

  mvnParameters = toString [
    "-DskipTests=true" # skip tests (out of memory execptions)
    "-Dossindex.skip" # skip dependency with vulnerability (recommended by upstream)
  ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    # Note: using * instead of version would match multiple files
    install -Dm644 tika-app/target/tika-app-${version}.jar $out/share/tika/tika-app.jar
    install -Dm644 tika-server/tika-server-standard/target/tika-server-standard-${version}.jar $out/share/tika/tika-server.jar

    makeWrapper ${jdk8.jre}/bin/java $out/bin/tika-app \
        --add-flags "-jar $out/share/tika/tika-app.jar"
    makeWrapper ${jdk8.jre}/bin/java $out/bin/tika-server \
        --prefix PATH : ${lib.makeBinPath [ jdk8.jre ]} \
        --add-flags "-jar $out/share/tika/tika-server.jar"

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/apache/tika/blob/${src.rev}/CHANGES.txt";
    description = "A toolkit for extracting metadata and text from over a thousand different file types";
    longDescription = ''
      The Apache Tika™ toolkit detects and extracts metadata and text
      from over a thousand different file types (such as PPT, XLS, and PDF).
      All of these file types can be parsed through a single interface,
      making Tika useful for search engine indexing, content analysis,
      translation, and much more.
    '';
    homepage = "https://tika.apache.org";
    license = lib.licenses.asl20;
    mainProgram = "tika-server";
    maintainers = with lib.maintainers; [ tomasajt ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # maven dependencies
    ];
  };
}
