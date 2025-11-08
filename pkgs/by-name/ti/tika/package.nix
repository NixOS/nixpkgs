{
  lib,
  stdenv,
  maven,
  jdk17,
  jre17_minimal,
  fetchFromGitHub,
  fetchpatch,
  makeWrapper,
  mvnDepsHash ? null,
  enableGui ? true,
  enableOcr ? true,
  runCommand,
  tesseract,
  nixosTests,
}:

let
  mvnDepsHashes = {
    "x86_64-linux" = "sha256-OTd51n6SSlFziqvvHmfyMAyQRwIzsHxFGuJ62zlX1Ec=";
    "aarch64-linux" = "sha256-tPaGLqm0jgEoz0BD/C6AG9xupovQvib/v0kB/jjqwB8=";
    "x86_64-darwin" = "sha256-Rs7nTiGazUW8oJJr6fbJKelzFqd2n278sJYoMy2/0N4=";
    "aarch64-darwin" = "sha256-gnP+G33LPRMQ6HRzeZ8cEV9oSohrlPcMwlBB4rvH7+E=";
  };

  knownMvnDepsHash =
    mvnDepsHashes.${stdenv.system}
      or (lib.warn "This platform doesn't have a default mvnDepsHash value, you'll need to specify it manually" lib.fakeHash);

  jdk = jre17_minimal.override {
    modules = [
      "java.base"
      "java.desktop"
      "java.logging"
      "java.management"
      "java.naming"
      "java.sql"
    ];
    jdk = jdk17;
  };
in
maven.buildMavenPackage rec {
  pname = "tika";
  version = "2.9.3";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "tika";
    tag = version;
    hash = "sha256-nuiE+MWJNA4PLprAC0vDBadk34TFsVEDBcCZct1XRxo=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2025-54988.patch";
      url = "https://github.com/apache/tika/commit/bfee6d5569fe9197c4ea947a96e212825184ca33.patch";
      hash = "sha256-LHM2SafZ85f53mWWSbA4ZQ/QSiDeiwNnzAbLGqGQqPM=";
    })
  ];

  buildOffline = true;

  manualMvnArtifacts = [
    "org.objenesis:objenesis:2.1"
    "org.apache.apache.resources:apache-jar-resource-bundle:1.5"
    "org.apache.maven.surefire:surefire-junit-platform:3.1.2"
    "org.junit.platform:junit-platform-launcher:1.10.0"
  ];

  mvnJdk = jdk17;
  mvnHash = if mvnDepsHash != null then mvnDepsHash else knownMvnDepsHash;

  mvnParameters = toString (
    [
      "-DskipTests=true" # skip tests (out of memory exceptions)
      "-Dossindex.skip" # skip dependency with vulnerability (recommended by upstream)
    ]
    ++ lib.optionals (!enableGui) [
      "-am -pl :tika-server-standard"
    ]
  );

  nativeBuildInputs = [ makeWrapper ];

  installPhase =
    let
      flags = "--add-opens java.base/jdk.internal.ref=ALL-UNNAMED --add-opens java.base/java.nio=ALL-UNNAMED";

      binPath = lib.makeBinPath (
        [
          (runCommand "jdk-tika"
            {
              nativeBuildInputs = [ makeWrapper ];
            }
            ''
              makeWrapper ${jdk}/bin/java $out/bin/java \
                --add-flags "${flags}"
            ''
          )
        ]
        ++ lib.optionals enableOcr [ tesseract ]
      );
    in
    ''
      runHook preInstall

      # Note: using * instead of version would match multiple files
    ''
    + lib.optionalString enableGui ''
      install -Dm644 tika-app/target/tika-app-${version}.jar $out/share/tika/tika-app.jar
      makeWrapper ${jdk}/bin/java $out/bin/tika-app \
          --add-flags "${flags} -jar $out/share/tika/tika-app.jar"
    ''
    + ''
      install -Dm644 tika-server/tika-server-standard/target/tika-server-standard-${version}.jar $out/share/tika/tika-server.jar
      makeWrapper ${jdk}/bin/java $out/bin/tika-server \
          --prefix PATH : ${binPath} \
          --add-flags "-jar $out/share/tika/tika-server.jar"

      runHook postInstall
    '';

  passthru.tests = {
    inherit (nixosTests) tika;
  };

  meta = {
    changelog = "https://github.com/apache/tika/blob/${src.rev}/CHANGES.txt";
    description = "Toolkit for extracting metadata and text from over a thousand different file types";
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
