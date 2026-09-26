{
  lib,
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "v2ray-rules-dat";
  version = "202609240010";

  __structuredAttrs = true;
  strictDeps = true;

  src = null;
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm444 ${finalAttrs.passthru.geoipDat} $out/share/v2ray/geoip.dat
    install -Dm444 ${finalAttrs.passthru.geositeDat} $out/share/v2ray/geosite.dat

    runHook postInstall
  '';

  passthru = {
    geoipDat = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/${finalAttrs.version}/geoip.dat";
      hash = "sha256-8zcM85GDG7AeHmYt+IWWFk0Tbn2fgakcALriZYfgLXI=";
    };
    geositeDat = fetchurl {
      url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/${finalAttrs.version}/geosite.dat";
      hash = "sha256-IkeYzPr0+wm+MbY8CAeylpZBp0NQkCx2kmpsDp0zR7o=";
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
