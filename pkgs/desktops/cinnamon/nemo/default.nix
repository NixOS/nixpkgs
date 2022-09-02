{ fetchFromGitHub
, fetchpatch
, glib
, gobject-introspection
, meson
, ninja
, pkg-config
, lib
, stdenv
, wrapGAppsHook
, libxml2
, gtk3
, gvfs
, cinnamon-desktop
, xapp
, libexif
, exempi
, intltool
, shared-mime-info
, cinnamon-translations
, libgsf
}:

stdenv.mkDerivation rec {
  pname = "nemo";
  version = "5.4.3";

  # TODO: add plugins support (see https://github.com/NixOS/nixpkgs/issues/78327)

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "sha256-f3rO0lpOcwpSpIpKrslf6/6nqFbbGTwnKbHpWO+Uf+Q=";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [
    glib
    gtk3
    cinnamon-desktop
    libxml2
    xapp
    libexif
    exempi
    gvfs
    gobject-introspection
    libgsf
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
    # use locales from cinnamon-translations
    "--localedir=${cinnamon-translations}/share/locale"
  ];

  meta = with lib; {
    homepage = "https://github.com/linuxmint/nemo";
    description = "File browser for Cinnamon";
    license = [ licenses.gpl2 licenses.lgpl2 ];
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}

