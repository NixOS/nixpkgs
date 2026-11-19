{
  lib,
  maven,
  fetchFromGitHub,
  jre,
  makeWrapper,
}:

maven.buildMavenPackage rec {
  pname = "zxing";
  version = "3.5.4";

  src = fetchFromGitHub {
    owner = "zxing";
    repo = "zxing";
    tag = "zxing-${version}";
    hash = "sha256-D+ZKfDa406RIaTRhH9yXxgP8EpGe0iQU9CqkOMC4UdE=";
  };

  mvnHash = "sha256-n5Q/EbWlKsKwDkCDrZPlHB8QVWECSPClxevhsZBjNDU=";

  sourceRoot = "${src.name}/javase";

  nativeBuildInputs = [ makeWrapper ];

  mvnParameters = "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z compile assembly:single";

  installPhase = ''
    runHook preInstall

    local -r jar="javase-${version}-jar-with-dependencies.jar"
    local -r libs="$out/lib/java"
    local -r java="$out/bin/java-zxing"
    local -r zxing="$out/bin/zxing"

    wrapJava () {
        makeWrapper "$java" "$out/bin/zxing-$1" --add-flag "com.google.zxing.client.j2se.$2"
    }

    install -Dt "$libs" "target/$jar"

    makeWrapper "${lib.getExe jre}" "$java" --add-flags "-cp $libs/$jar"

    wrapJava cmdline-encoder CommandLineEncoder
    wrapJava cmdline-runner CommandLineRunner
    wrapJava gui-runner GUIRunner

    substitute "${./zxing.sh}" "$zxing" --subst-var out
    chmod +x "$zxing"

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/zxing/zxing/releases/tag/zxing-${version}";
    description = "1D and 2D code reading library";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      fromSource
    ];
    license = lib.licenses.asl20;
    mainProgram = "zxing";
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    homepage = "https://github.com/zxing/zxing";
  };
}
