{
  lib,
  stdenv,
  fetchzip,
  replaceVars,
}:

{ version, src, ... }:

let
  inherit (stdenv.hostPlatform) system;
  selectSystem =
    attrs: attrs.${system} or (throw "metadata_god: ${stdenv.hostPlatform.system} is not supported");
  suffix = selectSystem {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
  };
  metadata_god = fetchzip {
    url = "https://github.com/KRTirtho/frb_plugins/releases/download/metadata_god-v0.5.3/linux.tar.gz";
    hash = "sha256-ZR/q1dF8w4Yab6dRRiS5ZCChVnoecFUrtGiHXGlll9A=";
    stripRoot = false;
  };
in
stdenv.mkDerivation {
  pname = "metadata_god";
  inherit version src;
  inherit (src) passthru;

  patches = [
    (replaceVars ./metadata_god.patch {
      output_lib = "${metadata_god}/${suffix}/libmetadata_god.so";
    })
  ];

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';

  meta.sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
}
