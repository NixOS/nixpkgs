{
  stdenvNoCC,
  fetchurl,
  lib,
}:
let
  version = "202606122311";

  geoipDat = fetchurl {
    url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/${version}/geoip.dat";
    hash = "sha256-iGGpeUaWtIH7AEPueCssQOgL/Ia7nkLFvWnAj1SDsbU=";
  };

  geositeDat = fetchurl {
    url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/${version}/geosite.dat";
    hash = "sha256-/c/3OjfALveNnHS9NxonTeOiZyud6U/X4WHrGZSOs7Q=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "v2ray-rules-dat";
  inherit version;
  __structuredAttrs = true;
  strictDeps = true;
  dontUnpack = true;

  installPhase = ''
    install -Dm444 ${geoipDat} $out/share/v2ray/geoip.dat
    install -Dm444 ${geositeDat} $out/share/v2ray/geosite.dat
  '';

  meta = {
    description = "Enhanced edition of V2Ray rules dat files";
    homepage = "https://github.com/Loyalsoldier/v2ray-rules-dat";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ nix-julia ];
  };
}
