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
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "wayland-utils";
  version = "1.3.0";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/wayland/wayland-utils/-/releases/${version}/downloads/wayland-utils-${version}.tar.xz";
    hash = "sha256-o50OZWF8auGG12jCI/VwYKOkNfb58C0DB0+UUxO/zw0=";
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

  passthru.updateScript = gitUpdater {
    url = "https://gitlab.freedesktop.org/wayland/wayland-utils.git";
  };

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
    maintainers = with maintainers; [ wineee ];
    mainProgram = "wayland-info";
  };
}
