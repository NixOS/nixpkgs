{
  lib,
  stdenvNoCC,
  fetchzip,
  nix-update-script,

}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "xray-rules-dat";
  version = "26.11.9";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchzip {
    # We cannot use Xray-rules-dat releases directly because they are only kept for 7 days.
    # The architecture doesn't matter since we only use geoip.dat and geosite.dat, so the smallest bundle is chosen.
    url = "https://github.com/XTLS/Xray-core/releases/download/v${finalAttrs.version}/Xray-openbsd-arm64-v8a.zip";
    hash = "sha256-4HJt0q0bDWJCvY790gHwp2QFDs9xKJLxzXoVEH2pvwA=";
    stripRoot = false;
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/v2ray # Use the v2ray directory name for compatibility.
    ln -s ${finalAttrs.src}/geoip.dat $out/share/v2ray/geoip.dat
    ln -s ${finalAttrs.src}/geosite.dat $out/share/v2ray/geosite.dat

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "GeoIP and GeoSite data for Xray";
    homepage = "https://github.com/XTLS/Xray-rules-dat";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nix-julia ];
  };
})
