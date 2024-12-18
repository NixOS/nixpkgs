{
  stdenv,
  fetchurl,
  graalvmCEPackages,
}:

graalvmCEPackages.buildGraalvmProduct {
  src = fetchurl (import ./hashes.nix).hashes.${stdenv.system};
  version = (import ./hashes.nix).version;

  product = "graalpy";

  doInstallCheck = true;
  installCheckPhase = ''
    echo "Testing GraalPy"
    $out/bin/graalpy -c 'print(1 + 1)'
    echo '1 + 1' | $out/bin/graalpy
  '';
}
