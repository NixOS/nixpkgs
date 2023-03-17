{ lib
, stdenv
, graalvm-ce
, graalvmCEPackages
, javaVersion
, src
, version
}:

graalvmCEPackages.buildGraalvmProduct rec {
  inherit src javaVersion version;
  product = "wasm-installable-svm";

  # TODO: improve this test
  graalvmPhases.installCheckPhase = ''
    echo "Testing wasm"
    $out/bin/wasm --help
  '';

  # Not supported in aarch64-darwin yet as GraalVM 22.3.1 release
  meta.platforms = builtins.filter (p: p != "aarch64-darwin") graalvm-ce.meta.platforms;
}
