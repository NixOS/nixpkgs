{
  lib,
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "v2ray-rules-dat";
  version = "202611082203";

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
      hash = "sha256-kLeKuGHBzcP4cfMF+c7t+41tYynjpAKV5nc+BXKXOEw=";
    };
    geositeDat = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/${finalAttrs.version}/geosite.dat";
      hash = "sha256-l+8qBgo6tghA91oTXCaHLE4fuqKEfQ9N5XqSdGD3Hog=";
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
