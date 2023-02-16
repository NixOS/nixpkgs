{ lib
, stdenv
, graalvmCEPackages
, graalvm-ce
, javaVersion
, src
, version
}:

graalvmCEPackages.buildGraalvmProduct rec {
  inherit src javaVersion version;
  product = "nodejs-installable-svm";

  extraNativeBuildInputs = [ graalvm-ce ];

  # TODO: improve test
  graalvmPhases.installCheckPhase = ''
    echo "Testing NodeJS"
    $out/bin/npx --help
  '';
}
