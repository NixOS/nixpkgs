{ lib
, stdenv
, graalvmCEPackages
, javaVersion
, src
, version
}:

graalvmCEPackages.buildGraalvmProduct rec {
  inherit src javaVersion version;
  product = "llvm-installable-svm";

  # TODO: improve this test
  graalvmPhases.installCheckPhase = ''
    echo "Testing llvm"
    $out/bin/lli --help
  '';
}
