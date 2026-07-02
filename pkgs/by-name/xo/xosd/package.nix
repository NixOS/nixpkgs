{
  lib,
  stdenv,
  fetchurl,
  libx11,
  libxext,
  libxt,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xosd";
  version = "2.2.14";

  src = fetchurl {
    url = "mirror://sourceforge/libxosd/xosd-${finalAttrs.version}.tar.gz";
    sha256 = "025m7ha89q29swkc7s38knnbn8ysl24g2h5s7imfxflm91psj7sg";
  };

  buildInputs = [
    libx11
    libxext
    libxt
    xorgproto
  ];

  meta = {
    description = "Displays text on your screen";
    homepage = "https://sourceforge.net/projects/libxosd";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ pSub ];
  };
})
