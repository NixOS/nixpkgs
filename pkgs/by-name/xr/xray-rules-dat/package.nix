{
  lib,
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "xray-rules-dat";
  version = "20261028222509";

  __structuredAttrs = true;
  strictDeps = true;

  src = null;
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm444 ${finalAttrs.passthru.geoipLiteDat} $out/share/xray/geoip.dat
    install -Dm444 ${finalAttrs.passthru.geositeDat} $out/share/xray/geosite.dat

    runHook postInstall
  '';

  passthru = {
    geoipLiteDat = fetchurl {
      url = "https://github.com/XTLS/Xray-rules-dat/releases/download/${finalAttrs.version}/geoip-lite.dat";
      hash = "sha256-NuDnYUXbo/E6xL974Lc41+rpV4Nf79LuIg5wNP5SpNE=";
    };
    geositeDat = fetchurl {
      url = "https://github.com/XTLS/Xray-rules-dat/releases/download/${finalAttrs.version}/geosite.dat";
      hash = "sha256-uKMc4S0+yZc1i/K96VvlAt90AhedHJPR6LPtpvewjzo=";
    };
    updateScript = ./update.sh;
  };

  meta = {
    description = "GeoIP and GeoSite data for Xray";
    homepage = "https://github.com/XTLS/Xray-rules-dat";
    changelog = "https://github.com/XTLS/Xray-rules-dat/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nix-julia ];
  };
})
