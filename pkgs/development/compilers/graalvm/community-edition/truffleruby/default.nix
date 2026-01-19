{
  lib,
  stdenv,
  fetchurl,
  graalvmPackages,
  libyaml,
  openssl,
}:

graalvmPackages.buildGraalvmProduct {
  src = fetchurl (import ./hashes.nix).hashes.${stdenv.system};
  version = (import ./hashes.nix).version;

  product = "truffleruby";

  extraBuildInputs = [
    libyaml
    openssl
  ];

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/lib/mri/openssl.so \
      --replace-needed libssl.so.10 libssl.so \
      --replace-needed libcrypto.so.10 libcrypto.so
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    echo "Testing TruffleRuby"
    # Fixup/silence warnings about wrong locale
    export LANG=C
    export LC_ALL=C
    $out/bin/ruby -e 'puts(1 + 1)'
    ${
      # broken in darwin with sandbox enabled
      lib.optionalString stdenv.hostPlatform.isLinux ''
        echo '1 + 1' | $out/bin/irb
      ''
    }
  '';
}
