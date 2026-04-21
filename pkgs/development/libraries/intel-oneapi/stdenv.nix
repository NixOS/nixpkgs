{
  kit,
  stdenvNoCC,
  stdenv,
  overrideCC,
  wrapCCWith,
}:
let
  unwrappedCC = stdenvNoCC.mkDerivation {
    name = "intel-oneapi-cc-unwrapped";
    dontUnpack = true;

    # Note: use a wrapper script, not symlinks. The compiler inspects argv[0]
    #       to decide how to behave, so it must see itself invoked as
    #       icx/icpx. Through a symlink it would see clang/clang++ and
    #       select the wrong behavior.
    installPhase = ''
      mkdir -p $out/bin

      cat > $out/bin/clang++ << 'EOF'
      #!/bin/sh
      exec ${kit}/compiler/latest/bin/icpx "$@"
      EOF
      chmod +x $out/bin/clang++

      cat > $out/bin/clang << 'EOF'
      #!/bin/sh
      exec ${kit}/compiler/latest/bin/icx "$@"
      EOF
      chmod +x $out/bin/clang
    '';

    passthru.isClang = true;

    # icpx rejects these flags for the SPIR-V device target (spir64-unknown-unknown).
    hardeningUnsupportedFlags = [
      "zerocallusedregs"
      "pacret"
      "shadowstack"
    ];
  };

  wrappedCC = wrapCCWith {
    cc = unwrappedCC;
    extraPackages = [ kit ];
    extraBuildCommands = ''
      # Consumers expect the icpx/icx names and might reject clang++/clang.
      ln -s $out/bin/clang++ $out/bin/icpx
      ln -s $out/bin/clang   $out/bin/icx

      echo "export CXX=\"$out/bin/icpx\"" >> $out/nix-support/setup-hook
      echo "export CC=\"$out/bin/icx\"" >> $out/nix-support/setup-hook

      echo "export ONEAPI_ROOT=\"${kit}\"" >> $out/nix-support/setup-hook
    '';
  };
in
overrideCC stdenv wrappedCC
