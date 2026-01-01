{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rgb";
<<<<<<< HEAD
  version = "1.1.1";

  src = fetchurl {
    url = "https://xorg.freedesktop.org/archive/individual/app/rgb-${finalAttrs.version}.tar.xz";
    hash = "sha256-yA/ygKAvVsMPrcLfohD8aXnEq5aK+jFSeMuXdotk7Ks=";
=======
  version = "1.1.0";

  src = fetchurl {
    url = "https://xorg.freedesktop.org/archive/individual/app/rgb-${finalAttrs.version}.tar.xz";
    hash = "sha256-/APX9W5bKmF2aBZ/iSeUjM5U+TCX58zZ8FYHf0ee03s=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ xorgproto ];

<<<<<<< HEAD
  meta = {
    description = "X11 colorname to RGB mapping database";
    mainProgram = "showrgb";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "X11 colorname to RGB mapping database";
    mainProgram = "showrgb";
    license = licenses.mit;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://xorg.freedesktop.org/";
  };
})
