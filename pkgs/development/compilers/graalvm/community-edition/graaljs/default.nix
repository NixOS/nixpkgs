{ stdenv
, fetchurl
, graalvmCEPackages
}:

graalvmCEPackages.buildGraalvmProduct {
  src = fetchurl (import ./hashes.nix).hashes.${stdenv.system};
  version = (import ./hashes.nix).version;

  product = "js-installable-svm";

  doInstallCheck = true;
  installCheckPhase = ''
    echo "Testing GraalJS"
    echo '1 + 1' | $out/bin/js
  '';
}
