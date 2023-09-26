{ graalvmCEPackages
, src
, version
}:

graalvmCEPackages.buildGraalvmProduct {
  inherit src version;
  product = "js-installable-svm";

  doInstallCheck = true;
  installCheckPhase = ''
    echo "Testing GraalJS"
    echo '1 + 1' | $out/bin/js
  '';
}
