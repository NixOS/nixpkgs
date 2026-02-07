{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ttf-bitstream-vera";
  version = "1.10";

  src = fetchurl {
    url = "mirror://gnome/sources/ttf-bitstream-vera/${lib.versions.majorMinor finalAttrs.version}/ttf-bitstream-vera-${finalAttrs.version}.tar.bz2";
    hash = "sha256-21sn33u7MYA269t1rNPpjxvW62YI+3CmfUeM0kPReNw=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/truetype *.ttf

    runHook postInstall
  '';

  meta = { };
})
