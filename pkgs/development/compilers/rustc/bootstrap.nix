{ stdenv, fetchurl, makeWrapper }:

let
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
    then "2951dec835827974d03c7aafbf2c969f39bb530e1c200fd46f90bc01772fae39"
    else if stdenv.system == "x86_64-linux"
    then "d0704d10237c66c3efafa6f7e5570c59a1d3fe5c6d99487540f90ebb37cd84c4"
    else if stdenv.system == "i686-darwin"
    then "c7aa93e2475aa8e65259f606ca70e98da41cf5d2b20f91703b98f9572a84f7e6"
    else if stdenv.system == "x86_64-darwin"
    then "7204226b42e9c380d44e722efd4a886178a1867a064c90f12e0553a21a4184c6"
    else throw "missing boostrap hash for platform ${stdenv.system}";
in
stdenv.mkDerivation rec {
  name = "rustc-bootstrap-${version}";
  version = "1.9.0";
  src = fetchurl {
     url = "https://static.rust-lang.org/dist/rustc-${version}-${platform}.tar.gz";
     sha256 = bootstrapHash;
  };
  buildInputs = [makeWrapper];
  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir -p "$out"
    ./install.sh "--prefix=$out"

    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      "$out/bin/rustc"

    wrapProgram "$out/bin/rustc"
  '';
}
