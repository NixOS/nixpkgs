{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, fetchpatch
, meson
, ninja
, pkg-config
, wayland-protocols
, wayland-scanner
, inih
, libdrm
, mesa
, scdoc
, systemd
, wayland
,
}:

stdenv.mkDerivation {
  pname = "xdg-desktop-portal-termfilechooser";
  version = "0-unstable-2021-07-14";

  src = fetchFromGitHub {
    owner = "GermainZ";
    repo = "xdg-desktop-portal-termfilechooser";
    rev = "71dc7ab06751e51de392b9a7af2b50018e40e062";
    hash = "sha256-645hoLhQNncqfLKcYCgWLbSrTRUNELh6EAdgUVq3ypM=";
  };

  strictDeps = true;

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
    makeWrapper
  ];

  buildInputs = [
    inih
    libdrm
    mesa
    systemd
    wayland
    wayland-protocols
  ];

  mesonFlags = [
    (lib.mesonOption "sd-bus-provider" "libsystemd")
    (lib.mesonOption "sysconfdir" "/etc")
  ];

  patches = [
    # Allow using the default version, by removing hard-coded paths in the ranger wrapper
    # https://github.com/GermainZ/xdg-desktop-portal-termfilechooser/pull/9
    (fetchpatch {
      name = "dont_hardcode_kitty.patch";
      url = "https://github.com/GermainZ/xdg-desktop-portal-termfilechooser/commit/af0ae142f54dbf9b480b5c886bfb1319cd6ff25b.patch";
      hash = "sha256-AgLetBd9sP3G3OPpweVA0Qp9njfPVFXJi4m/rZsSxJc=";
    })
    (fetchpatch {
      name = "dont_hardcode_ranger.patch";
      url = "https://github.com/GermainZ/xdg-desktop-portal-termfilechooser/commit/4e0db3d4c1639582420847393884ca6bb990cfe5.patch";
      hash = "sha256-jMNVcwm6zEdOvaTRbw5bfaJ2sLuxfuk7+6DlB1HOkYo=";
    })
  ];

  postPatch = ''
    # Allow using ranger out of the box without any configuration.
    substituteInPlace src/core/config.c \
      --replace-fail '"/usr/share/xdg-desktop-portal-termfilechooser/ranger-wrapper.sh"' '"${placeholder "out"}/share/xdg-desktop-portal-termfilechooser/ranger-wrapper.sh"'

    # Fix comparison between char and int
    substituteInPlace src/filechooser/filechooser.c \
      --replace-fail 'char cr' 'int cr'
  '';

  meta = {
    homepage = "https://github.com/GermainZ/xdg-desktop-portal-termfilechooser";
    description = "Xdg-desktop-portal backend for wlroots and the likes of ranger";
    maintainers = with lib.maintainers; [ soispha ];
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
  };
}
