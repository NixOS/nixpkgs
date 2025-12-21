{
  lib,
  maven,
  fetchFromGitHub,
  jre,
}:

maven.buildMavenPackage rec {
  pname = "zxing";
  version = "3.5.4";

  inherit jre;

  src = fetchFromGitHub {
    owner = "zxing";
    repo = "zxing";
    tag = "zxing-${version}";
    hash = "sha256-D+ZKfDa406RIaTRhH9yXxgP8EpGe0iQU9CqkOMC4UdE=";
  };

  mvnHash = "sha256-wVkWbhi5b/rZ0EF5zlQr2BMVOm5nZ1DhI6SGksZO5Vg=";

  sourceRoot = "${src.name}/javase";

  mvnParameters = "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z compile assembly:single";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/java" "$out/bin"
    cp "target/javase-${version}-jar-with-dependencies.jar" "$out/lib/java"
    substituteAll "${./java-zxing.sh}" "$out/bin/java-zxing"
    substituteAll "${./zxing-cmdline-runner.sh}" "$out/bin/zxing-cmdline-runner"
    substituteAll "${./zxing-cmdline-encoder.sh}" "$out/bin/zxing-cmdline-encoder"
    substituteAll "${./zxing.sh}" "$out/bin/zxing"
    chmod a+x "$out/bin"/*

    runHook postInstall
  '';

  meta = {
    description = "1D and 2D code reading library";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      fromSource
    ];
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    homepage = "https://github.com/zxing/zxing";
  };
}
