{ stdenv, fetchurl, makeWrapper, cacert, zlib, buildRustPackage, curl
, version
, src
, platform
, versionType
}:

let
  inherit (stdenv.lib) optionalString;

  needsPatchelf = stdenv.isLinux;

  bootstrapping = versionType == "bootstrap";

  installComponents
    = "rustc,rust-std-${platform}"
    + (optionalString bootstrapping ",rust-docs,cargo")
    ;
in

rec {
  inherit buildRustPackage;

  rustc = stdenv.mkDerivation rec {
    name = "rustc-${versionType}-${version}";

    inherit version;
    inherit src;

    meta = with stdenv.lib; {
      homepage = http://www.rust-lang.org/;
      description = "A safe, concurrent, practical language";
      maintainers = with maintainers; [ qknight ];
      license = [ licenses.mit licenses.asl20 ];
    };

    phases = ["unpackPhase" "installPhase"];

    installPhase = ''
      ./install.sh --prefix=$out \
        --components=${installComponents}

      ${optionalString (needsPatchelf && bootstrapping) ''
        patchelf \
          --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
          "$out/bin/rustdoc"
        patchelf \
          --set-rpath "${stdenv.lib.makeLibraryPath [ curl zlib ]}" \
          --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
          "$out/bin/cargo"
      ''}

      ${optionalString needsPatchelf ''
        patchelf \
          --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
          "$out/bin/rustc"

      # Do NOT, I repeat, DO NOT use `wrapProgram` on $out/bin/rustc
      # (or similar) here. It causes strange effects where rustc loads
      # the wrong libraries in a bootstrap-build causing failures that
      # are very hard to track dow. For details, see
      # https://github.com/rust-lang/rust/issues/34722#issuecomment-232164943
      ''}
    '';

  };

  cargo = stdenv.mkDerivation rec {
    name = "cargo-${versionType}-${version}";

    inherit version;
    inherit src;

    meta = with stdenv.lib; {
      homepage = http://www.rust-lang.org/;
      description = "A safe, concurrent, practical language";
      maintainers = with maintainers; [ qknight ];
      license = [ licenses.mit licenses.asl20 ];
    };

    buildInputs = [ makeWrapper ];
    phases = ["unpackPhase" "installPhase"];

    installPhase = ''
      ./install.sh --prefix=$out \
        --components=cargo

      ${optionalString needsPatchelf ''
        patchelf \
          --set-rpath "${stdenv.lib.makeLibraryPath [ curl zlib ]}" \
          --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
          "$out/bin/cargo"
      ''}

      wrapProgram "$out/bin/cargo" \
        --suffix PATH : "${rustc}/bin"
    '';
  };
}
