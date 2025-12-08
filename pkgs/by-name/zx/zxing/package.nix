{
  lib,
  stdenv,
  fetchurl,
  jre,
}:

let
  version = "3.5.4";

  # Maven builds are hard to get right
  core_jar = fetchurl {
    url = "https://repo1.maven.org/maven2/com/google/zxing/core/${version}/core-${version}.jar";
    hash = "sha256-cd5diTQbX89d2J2n9E6E2CXQ4ITN8+x3yaviaw8M6xM=";
  };

  javase_jar = fetchurl {
    url = "https://repo1.maven.org/maven2/com/google/zxing/javase/${version}/javase-${version}.jar";
    hash = "sha256-GWaDH0c9cv93IFeEGasRP2QXqXI0oXENK8zGUPWuDBI=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zxing";
  inherit version jre;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/java" "$out/bin"
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

    runHook postInstall
  '';

  meta = {
    description = "1D and 2D code reading library";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    homepage = "https://github.com/zxing/zxing";
  };
})
