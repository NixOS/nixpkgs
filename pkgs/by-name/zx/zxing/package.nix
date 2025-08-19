{
  lib,
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
