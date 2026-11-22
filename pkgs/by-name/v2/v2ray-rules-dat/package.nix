{
  lib,
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "v2ray-rules-dat";
  version = "202611202204";

  __structuredAttrs = true;
  strictDeps = true;

  src = null;
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/v2ray
    ln -s ${finalAttrs.passthru.geoipDat} $out/share/v2ray/geoip.dat
    ln -s ${finalAttrs.passthru.geositeDat} $out/share/v2ray/geosite.dat

    runHook postInstall
  '';

  passthru = {
    geoipDat = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/${finalAttrs.version}/geoip.dat";
      hash = "sha256-1OxMXl1aOME5mWTqn9jJQohCajsxtIOQS2eBn8B/RGY=";
    };
    geositeDat = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/${finalAttrs.version}/geosite.dat";
      hash = "sha256-8DINDPIkMerONFlGpfsZamZU4+JEQd/6PqOO8ozUQok=";
    };
    updateScript = ./update.sh;
  };

  meta = {
    description = "Enhanced edition of V2Ray rules dat files";
    homepage = "https://github.com/Loyalsoldier/v2ray-rules-dat";
    changelog = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nix-julia ];
  };
})
