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

  mvnHash = "sha256-G21YIzAuc4LZhVqPmd2i/N42anUzmfqyciYR5XclzKk=";

  sourceRoot = "${src.name}/javase";

  mvnParameters = "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z compile assembly:single";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/java" "$out/bin"
    cp "target/javase-${version}-jar-with-dependencies.jar" "$out/lib/java"
    for source in "${./java-zxing.sh}" "${./zxing-cmdline-encoder.sh}" "${./zxing-cmdline-runner.sh}" "${./zxing-gui-runner.sh}" "${./zxing.sh}"; do
        target="''${source#*-}"
        target="$out/bin/''${target%.sh}"
        substituteAll "$source" "$target"
        chmod a+x "$target"
    done

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
