{ lib
, stdenv
, graalvmCEPackages
, javaVersion
, src
, version
}:

graalvmCEPackages.buildGraalvmProduct rec {
  inherit src javaVersion version;
  product = "python-installable-svm";

  graalvmPhases.installCheckPhase = ''
    echo "Testing GraalPython"
    $out/bin/graalpy -c 'print(1 + 1)'
    echo '1 + 1' | $out/bin/graalpy
  '';
}
