{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rgb";
  version = "1.1.0";

  src = fetchurl {
    url = "https://xorg.freedesktop.org/archive/individual/app/rgb-${finalAttrs.version}.tar.xz";
    hash = "sha256-/APX9W5bKmF2aBZ/iSeUjM5U+TCX58zZ8FYHf0ee03s=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ xorgproto ];

  meta = {
    description = "X11 colorname to RGB mapping database";
    mainProgram = "showrgb";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux;
    homepage = "https://xorg.freedesktop.org/";
  };
})
