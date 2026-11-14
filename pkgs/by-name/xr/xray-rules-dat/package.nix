{
  lib,
  stdenvNoCC,
  fetchzip,
  nix-update-script,

}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "xray-rules-dat";
  version = "26.10.31";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchzip {
    # We cannot use Xray-rules-dat releases directly because they are only kept for 7 days.
    # The architecture doesn't matter since we only use geoip.dat and geosite.dat, so the smallest bundle is chosen.
    url = "https://github.com/XTLS/Xray-core/releases/download/v${finalAttrs.version}/Xray-openbsd-arm64-v8a.zip";
    hash = "sha256-3DI6jEb8+LlCK/+PQacX6CqhhfkNVBKH1xR9mY6u88g=";
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
