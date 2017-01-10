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
    else abort "missing boostrap url for platform ${stdenv.system}";

  # fetch hashes by running `print-hashes.sh 1.13.0`
  bootstrapHash =
    if stdenv.system == "i686-linux"
    then "239734113f6750d31085c7a08c260d492991cc1ef10817b6d44154515f3f9439"
    else if stdenv.system == "x86_64-linux"
    then "95f4c372b1b81ac1038161e87e932dd7ab875d25c167a861c3949b0f6a65516d"
    else if stdenv.system == "i686-darwin"
    then "f6e01cab3bf8d0a6fe9cc2447aa10ce894569daaa72d44063c229da918b96023"
    else if stdenv.system == "x86_64-darwin"
    then "f538ca5732b844cf7f00fc4aaaf200a49a845b58b4ec8aef38da0b00e2cf6efe"
    else throw "missing boostrap hash for platform ${stdenv.system}";

  needsPatchelf = stdenv.isLinux;

  src = fetchurl {
     url = "https://static.rust-lang.org/dist/rust-${version}-${platform}.tar.gz";
     sha256 = bootstrapHash;
  };

  version = "1.13.0";
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
