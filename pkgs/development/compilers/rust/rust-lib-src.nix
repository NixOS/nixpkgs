{ stdenv, rustc }:

stdenv.mkDerivation {
  name = "rust-lib-src";
  src = rustc.src;
  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mv library $out
  '';
}
