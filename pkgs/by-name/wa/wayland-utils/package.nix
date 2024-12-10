{
  lib,
  stdenv,
  fetchurl,
  meson,
  pkg-config,
  ninja,
  wayland-scanner,
  libdrm,
  wayland,
  wayland-protocols,
}:

stdenv.mkDerivation rec {
  pname = "wayland-utils";
  version = "1.2.0";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/wayland/wayland-utils/-/releases/${version}/downloads/wayland-utils-${version}.tar.xz";
    sha256 = "sha256-2SeMIlVFhogYAlQHUbzEJWkmK/gM2aybD9Ev9L0JqeQ=";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    wayland-scanner
  ];
  buildInputs = [
    libdrm
    wayland
    wayland-protocols
  ];

  meta = with lib; {
    description = "Wayland utilities (wayland-info)";
    longDescription = ''
      A collection of Wayland related utilities:
      - wayland-info: A utility for displaying information about the Wayland
        protocols supported by a Wayland compositor.
    '';
    homepage = "https://gitlab.freedesktop.org/wayland/wayland-utils";
    license = licenses.mit; # Expat version
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
    mainProgram = "wayland-info";
  };
}
