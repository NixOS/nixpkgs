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

  # fetch hashes by running `print-hashes.sh 1.9.0`
  bootstrapHash =
    if stdenv.system == "i686-linux"
    then "dd4d9bf1b9393867eb18d00431e8fb733894984f2c7b5154bc1b64d045077b45"
    else if stdenv.system == "x86_64-linux"
    then "288ff13efa2577e81c77fc2cb6e2b49b1ed0ceab51b4fa12f7efb87039ac49b7"
    else if stdenv.system == "i686-darwin"
    then "4d4d4b256d6bd6ae2527cf61007b2553de200f0a1910b7ad41e4f51d2b21e536"
    else if stdenv.system == "x86_64-darwin"
    then "d59b5509e69c1cace20a57072e3b3ecefdbfd8c7e95657b0ff2ac10aa1dfebe6"
    else throw "missing boostrap hash for platform ${stdenv.system}";

  src = fetchurl {
     url = "https://static.rust-lang.org/dist/rust-${version}-${platform}.tar.gz";
     sha256 = bootstrapHash;
  };

  version = "1.9.0";
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

      ${optionalString stdenv.isLinux ''
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

      ${optionalString stdenv.isLinux ''
        patchelf \
          --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
          "$out/bin/rustc"
       ''}

      wrapProgram "$out/bin/cargo" \
        --suffix PATH : "${rustc}/bin"
    '';
  };
}
