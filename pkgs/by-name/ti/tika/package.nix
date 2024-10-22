{
  lib,
  stdenv,
  maven,
  jdk8,
  fetchFromGitHub,
  makeWrapper,
  mvnDepsHash ? null,
  enableOcr ? true,
  tesseract,
  nixosTests,
}:

let
  mvnDepsHashes = {
    "x86_64-linux" = "sha256-M8O1EJtlTm+mVy/qxapRcBWxD14eYL/LLUxP2uOBoM4=";
    "aarch64-linux" = "sha256-+ewdV9g0MfgiBiRAimkIZp9lrOTKnKnBB1LqhIlOSaQ=";
    "x86_64-darwin" = "sha256-nUAy2+O8REuq6pOWb8d+/c/YxPxj+XwtCtkaxfihDzc=";
    "aarch64-darwin" = "sha256-D6adBXtBH1IokUwwA2Z6m+6rJP2xg6BK4rcPyDSgo6o=";
  };

  knownMvnDepsHash =
    mvnDepsHashes.${stdenv.system}
      or (lib.warn "This platform doesn't have a default mvnDepsHash value, you'll need to specify it manually" lib.fakeHash);
in
maven.buildMavenPackage rec {
  pname = "tika";
  version = "2.9.2";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "tika";
    rev = version;
    hash = "sha256-4pSQcLDKgIcU+YypJ/ywdthi6tI1852fGVOCREzUFH0=";
  };

  buildOffline = true;

  manualMvnArtifacts = [
    "org.objenesis:objenesis:2.1"
    "org.apache.apache.resources:apache-jar-resource-bundle:1.5"
    "org.apache.maven.surefire:surefire-junit-platform:3.1.2"
    "org.junit.platform:junit-platform-launcher:1.10.0"
  ];

  mvnJdk = jdk8;
  mvnHash = if mvnDepsHash != null then mvnDepsHash else knownMvnDepsHash;

  mvnParameters = toString [
    "-DskipTests=true" # skip tests (out of memory exceptions)
    "-Dossindex.skip" # skip dependency with vulnerability (recommended by upstream)
  ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase =
    let
      binPath = lib.makeBinPath ([ jdk8.jre ] ++ lib.optionals enableOcr [ tesseract ]);
    in
    ''
      runHook preInstall

      # Note: using * instead of version would match multiple files
      install -Dm644 tika-app/target/tika-app-${version}.jar $out/share/tika/tika-app.jar
      install -Dm644 tika-server/tika-server-standard/target/tika-server-standard-${version}.jar $out/share/tika/tika-server.jar

      makeWrapper ${jdk8.jre}/bin/java $out/bin/tika-app \
          --add-flags "-jar $out/share/tika/tika-app.jar"
      makeWrapper ${jdk8.jre}/bin/java $out/bin/tika-server \
          --prefix PATH : ${binPath} \
          --add-flags "-jar $out/share/tika/tika-server.jar"

      runHook postInstall
    '';

  passthru.tests = {
    inherit (nixosTests) tika;
  };

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
