{ stdenv, fetchurl, makeWrapper, channel, sources }:

with stdenv.lib;

let
  metadata = sources.${channel}.rust.${stdenv.system};
in stdenv.mkDerivation rec {
  name = "rustc-nightly-${metadata.version}";

  src = fetchurl {
    inherit (metadata) url sha256;
  };

  buildInputs = [ makeWrapper ];
  phases = ["unpackPhase" "installPhase"];

  CFG_DISABLE_LDCONFIG = 1;

  installPhase = ''
    ./install.sh --prefix=$out \
      --components=rustc,rust-std-x86_64-unknown-linux-gnu

    ${optionalString stdenv.isLinux ''
      interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
      for i in $out/bin/{rustc,rustdoc}; do
        patchelf --set-interpreter "$interp" "$i"
      done
    ''}
  '';

  meta = {
    homepage = http://www.rust-lang.org/;
    description = "A safe, concurrent, practical language";
    license = [ licenses.mit licenses.asl20 ];
    inherit rustMaintainers;
  };
}
