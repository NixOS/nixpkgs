{ graalvmCEPackages
, src
, version
}:

graalvmCEPackages.buildGraalvmProduct {
  inherit src version;
  product = "graalpy";

  doInstallCheck = true;
  installCheckPhase = ''
    echo "Testing GraalPy"
    $out/bin/graalpy -c 'print(1 + 1)'
    echo '1 + 1' | $out/bin/graalpy
  '';
}
