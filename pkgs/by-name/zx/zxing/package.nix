{
  lib,
<<<<<<< HEAD
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
=======
  stdenv,
  fetchurl,
  jre,
}:

let
  version = "3.5.3";

  # Maven builds are hard to get right
  core_jar = fetchurl {
    url = "https://repo1.maven.org/maven2/com/google/zxing/core/${version}/core-${version}.jar";
    hash = "sha256-jYBkwWNv2u9xid2QVcfVmVColAoS8ik5VkRuw8EJ/YI=";
  };

  javase_jar = fetchurl {
    url = "https://repo1.maven.org/maven2/com/google/zxing/javase/${version}/javase-${version}.jar";
    hash = "sha256-1leVt4nvrIohVssqS2SNIOWL/gNhMWW7Xc5ocOzveY4=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zxing";
  inherit version jre;

  dontUnpack = true;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/java" "$out/bin"
<<<<<<< HEAD
    cp "target/javase-${version}-jar-with-dependencies.jar" "$out/lib/java"
    for source in "${./java-zxing.sh}" "${./zxing-cmdline-encoder.sh}" "${./zxing-cmdline-runner.sh}" "${./zxing-gui-runner.sh}" "${./zxing.sh}"; do
        target="''${source#*-}"
        target="$out/bin/''${target%.sh}"
        substituteAll "$source" "$target"
        chmod a+x "$target"
    done
=======
    cp "${core_jar}" "${javase_jar}" "$out/lib/java"
    substituteAll "${./java-zxing.sh}" "$out/bin/java-zxing"
    substituteAll "${./zxing-cmdline-runner.sh}" "$out/bin/zxing-cmdline-runner"
    substituteAll "${./zxing-cmdline-encoder.sh}" "$out/bin/zxing-cmdline-encoder"
    substituteAll "${./zxing.sh}" "$out/bin/zxing"
    chmod a+x "$out/bin"/*
    pushd "$out/lib/java"
    for i in *.jar; do
      mv "$i" "''${i#*-}"
    done
    popd
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    runHook postInstall
  '';

  meta = {
<<<<<<< HEAD
    changelog = "https://github.com/zxing/zxing/releases/tag/zxing-${version}";
    description = "1D and 2D code reading library";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      fromSource
    ];
    license = lib.licenses.asl20;
    mainProgram = "zxing";
=======
    description = "1D and 2D code reading library";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    homepage = "https://github.com/zxing/zxing";
  };
<<<<<<< HEAD
}
=======
})
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
