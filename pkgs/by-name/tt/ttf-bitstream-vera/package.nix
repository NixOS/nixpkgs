{
  lib,
  stdenvNoCC,
  fetchurl,
  installFonts,
  gnome,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ttf-bitstream-vera";
  version = "1.10";

  src = fetchurl {
    url = "mirror://gnome/sources/ttf-bitstream-vera/${lib.versions.majorMinor finalAttrs.version}/ttf-bitstream-vera-${finalAttrs.version}.tar.bz2";
    hash = "sha256-21sn33u7MYA269t1rNPpjxvW62YI+3CmfUeM0kPReNw=";
  };

  nativeBuildInputs = [ installFonts ];

  passthru.updateScript = gnome.updateScript {
    packageName = "ttf-bitstream-vera";
  };

  meta = {
    description = "Typeface superfamily based on Bitstream Prima";
    downloadPage = "https://download.gnome.org/sources/ttf-bitstream-vera/";
    license = lib.licenses.bitstreamVera;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
