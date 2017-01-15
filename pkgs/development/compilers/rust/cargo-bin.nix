{ stdenv, fetchurl, makeWrapper, sources, channel }:

with stdenv.lib;

let
  metadata = sources.${channel}.cargo.${stdenv.system};
in stdenv.mkDerivation rec {
  name = "cargo-nightly-${metadata.version}";

  src = fetchurl {
    inherit (metadata) url sha256;
  };

  buildInputs = [ makeWrapper ];
  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    ./install.sh --prefix=$out --components=cargo

    ${optionalString stdenv.isLinux ''
      patchelf \
        --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
        "$out/bin/cargo"
    ''}
  '';

  meta = {
    homepage = http://www.rust-lang.org/;
    description = "Downloads your Rust project's dependencies and builds your project";
    license = [ licenses.mit licenses.asl20 ];
    inherit rustMaintainers;
  };
}
