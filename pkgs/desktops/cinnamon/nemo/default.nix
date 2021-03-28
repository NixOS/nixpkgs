{ fetchFromGitHub
, fetchpatch
, glib
, gobject-introspection
, meson
, ninja
, pkg-config
, lib, stdenv
, wrapGAppsHook
, libxml2
, gtk3
, libnotify
, cinnamon-desktop
, xapps
, libexif
, exempi
, intltool
, shared-mime-info
}:

stdenv.mkDerivation rec {
  pname = "nemo";
  version = "4.6.5";

  # TODO: add plugins support (see https://github.com/NixOS/nixpkgs/issues/78327)

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "04rgdph9pxdj5wzzv2i0pgyhg3s74nh9jf1ry9z6v5bvv222ili4";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [
    glib
    gtk3
    libnotify
    cinnamon-desktop
    libxml2
    xapps
    libexif
    exempi
    gobject-introspection
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    wrapGAppsHook
    intltool
    shared-mime-info
  ];

  mesonFlags = [
    # TODO: https://github.com/NixOS/nixpkgs/issues/36468
    "-Dc_args=-I${glib.dev}/include/gio-unix-2.0"
  ];

  meta = with lib; {
    homepage = "https://github.com/linuxmint/nemo";
    description = "File browser for Cinnamon";
    license = [ licenses.gpl2 licenses.lgpl2 ];
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
