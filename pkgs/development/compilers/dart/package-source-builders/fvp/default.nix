{
  stdenv,
  mdk-sdk,
}:

{ version, src, ... }:

stdenv.mkDerivation rec {
  pname = "fvp";
  inherit version src;
  inherit (src) passthru;

  installPhase = ''
    runHook preInstall
    mkdir $out
    tar -xf ${mdk-sdk.src} -C ./linux
    cp -r ./* $out/
    runHook postInstall
  '';
}
