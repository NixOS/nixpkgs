{ stdenv, fetchurl, makeWrapper, cacert, zlib }:

let
  inherit (stdenv.lib) optionalString;

  platform =
    if stdenv.system == "i686-linux"
    then "i686-unknown-linux-gnu"
    else if stdenv.system == "x86_64-linux"
    then "x86_64-unknown-linux-gnu"
    else if stdenv.system == "i686-darwin"
    then "i686-apple-darwin"
    else if stdenv.system == "x86_64-darwin"
    then "x86_64-apple-darwin"
    else throw "missing bootstrap url for platform ${stdenv.system}";

  # fetch hashes by running `print-hashes.sh 1.14.0`
  bootstrapHash =
    if stdenv.system == "i686-linux"
    then "8d5c75728b44468216f99651dfae9d60ae0696a77105dd2b02942d75f3256840"
    else if stdenv.system == "x86_64-linux"
    then "c71325cfea1b6f0bdc5189fa4c50ff96f828096ff3f7b5056367f9685d6a4d04"
    else if stdenv.system == "i686-darwin"
    then "fe1b3d67329a22d67e3b8db8858a43022e2e746dde60ef4a2db3f2cac16ea9bd"
    else if stdenv.system == "x86_64-darwin"
    then "3381341524b0184da5ed2cdcddc2a25e2e335e87f1cf676f64d98ee5e6479f20"
    else throw "missing bootstrap hash for platform ${stdenv.system}";

  needsPatchelf = stdenv.isLinux;

  src = fetchurl {
     url = "https://static.rust-lang.org/dist/rust-${version}-${platform}.tar.gz";
     sha256 = bootstrapHash;
  };

  version = "1.14.0";
in

rec {
  rustc = stdenv.mkDerivation rec {
    name = "rustc-bootstrap-${version}";

    inherit version;
    inherit src;

    buildInputs = [ makeWrapper ];
    phases = ["unpackPhase" "installPhase"];

    installPhase = ''
      ./install.sh --prefix=$out \
        --components=rustc,rust-std-${platform},rust-docs

      ${optionalString needsPatchelf ''
        patchelf \
          --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
          "$out/bin/rustc"
      ''}

      # Do NOT, I repeat, DO NOT use `wrapProgram` on $out/bin/rustc
      # (or similar) here. It causes strange effects where rustc loads
      # the wrong libraries in a bootstrap-build causing failures that
      # are very hard to track dow. For details, see
      # https://github.com/rust-lang/rust/issues/34722#issuecomment-232164943
    '';
  };

  cargo = stdenv.mkDerivation rec {
    name = "cargo-bootstrap-${version}";

    inherit version;
    inherit src;

    buildInputs = [ makeWrapper zlib rustc ];
    phases = ["unpackPhase" "installPhase"];

    installPhase = ''
      ./install.sh --prefix=$out \
        --components=cargo

      ${optionalString needsPatchelf ''
        patchelf \
          --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
          "$out/bin/cargo"
      ''}

      wrapProgram "$out/bin/cargo" \
        --suffix PATH : "${rustc}/bin"
    '';
  };
}
