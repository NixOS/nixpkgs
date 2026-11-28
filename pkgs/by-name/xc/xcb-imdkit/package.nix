{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  uthash,
  libxcb-util,
  libxcb-keysyms,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcb-imdkit";
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "xcb-imdkit";
    rev = finalAttrs.version;
    hash = "sha256-ERGdtSxi6082V2Fahr6oxFerYpYbX2jY4bB6xkD4C/I=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    xorgproto
    uthash
  ];

  buildInputs = [
    kdePackages.extra-cmake-modules
    libxcb-util
    libxcb-keysyms
  ];

  meta = {
    description = "Input method development support for xcb";
    homepage = "https://github.com/fcitx/xcb-imdkit";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ poscat ];
    platforms = lib.platforms.linux;
  };
})
