{ stdenv
, fetchurl
, graalvmCEPackages
}:

graalvmCEPackages.buildGraalvmProduct {
  src = fetchurl (import ./hashes.nix).hashes.${stdenv.system};
  version = (import ./hashes.nix).version;

  product = "nodejs-installable-svm";

  doInstallCheck = true;
  installCheckPhase = ''
    echo "Testing NodeJS"
    $out/bin/npx --help
  '';
}
