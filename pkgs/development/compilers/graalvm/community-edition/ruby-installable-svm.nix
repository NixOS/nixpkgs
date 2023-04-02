{ lib
, stdenv
, graalvmCEPackages
, llvm-installable-svm
, openssl
, javaVersion
, src
, version
}:

graalvmCEPackages.buildGraalvmProduct rec {
  inherit src javaVersion version;
  product = "ruby-installable-svm";

  extraBuildInputs = [
    llvm-installable-svm
    openssl
  ];

  preFixup = lib.optionalString stdenv.isLinux ''
    patchelf $out/languages/ruby/lib/mri/openssl.so \
      --replace-needed libssl.so.10 libssl.so \
      --replace-needed libcrypto.so.10 libcrypto.so
  '';

  graalvmPhases.installCheckPhase = ''
    echo "Testing TruffleRuby"
    # Fixup/silence warnings about wrong locale
    export LANG=C
    export LC_ALL=C
    $out/bin/ruby -e 'puts(1 + 1)'
    ${# broken in darwin with sandbox enabled
      lib.optionalString stdenv.isLinux ''
      echo '1 + 1' | $out/bin/irb
    ''}
  '';
}
