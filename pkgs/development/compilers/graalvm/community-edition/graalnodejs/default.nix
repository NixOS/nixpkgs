{ graalvmCEPackages
, src
, version
}:

graalvmCEPackages.buildGraalvmProduct {
  inherit src version;
  product = "nodejs-installable-svm";

  doInstallCheck = true;
  installCheckPhase = ''
    echo "Testing NodeJS"
    $out/bin/npx --help
  '';
}
