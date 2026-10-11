{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  kdePackages,

  libepoxy,
  libinput,
  libcap,
  como,
  wrapland,
  microsoft-gsl,
  pixman,
  wayland,
  wlroots,
  libdrm,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "theseus-ship";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "winft";
    repo = "theseus-ship";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-8KTTkOkYcltcYZ+arvhRQSrHiZDX6F3JwoXVXa8NFKU=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
    libcap
  ];

  buildInputs = with kdePackages; [
    kcrash
    kdbusaddons
    kwidgetsaddons
    kirigami
    kscreenlocker
    breeze
    wayland
    qtbase
    qttools

    libepoxy
    libinput
    como
    wrapland
    microsoft-gsl
    pixman
    wayland
    wlroots
    libdrm
  ];

  # It wants <drm_fourcc.h> and not <libdrm/drm_fourcc.h>
  env.NIX_CFLAGS_COMPILE = "-isystem ${lib.getDev libdrm}/include/libdrm";

  cmakeFlags = [
    # Otherwise the kcoreaddon plugin macro would try to write them to
    # /plasma (yes, top level). How fun!
    (lib.cmakeFeature "CMAKE_LIBRARY_OUTPUT_DIRECTORY" "${placeholder "out"}/lib")
  ];

  meta = {
    description = "Wayland and X11 Compositor for the KDE Plasma desktop";
    homepage = "https://github.com/winft/theseus-ship";
    license = with lib.licenses; [ gpl2Only ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pluiedev ];
  };
})
