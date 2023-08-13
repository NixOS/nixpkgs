{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, meson
, ninja
, glib
, dbus
, gettext
, cinnamon-desktop
, cinnamon-common
, intltool
, libxslt
, gtk3
, libgnomekbd
, gnome
, libtool
, wrapGAppsHook
, gobject-introspection
, python3
, pam
, accountsservice
, cairo
, xapp
, xdotool
, xorg
, iso-flags-png-320x420
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-screensaver";
  version = "5.8.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-d7h9OJ39HVQNCHNr13M1ybDFoU3Xnd1PEczGLHZU/lU=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook
    gettext
    intltool
    dbus # for meson.build
    libxslt
    libtool
    meson
    ninja
    gobject-introspection
  ];

  buildInputs = [
    # from meson.build
    gtk3
    glib

    xorg.libXext
    xorg.libXinerama
    xorg.libX11
    xorg.libXrandr

    (python3.withPackages (pp: with pp; [
      pygobject3
      setproctitle
      python3.pkgs.xapp # The scope prefix is required
      pycairo
    ]))
    xapp
    xdotool
    pam
    accountsservice
    cairo
    cinnamon-desktop
    cinnamon-common
    libgnomekbd
    gnome.caribou

    # things
    iso-flags-png-320x420
  ];

  postPatch = ''
    # cscreensaver hardcodes absolute paths everywhere. Nuke from orbit.
    find . -type f -exec sed -i \
      -e s,/usr/share/locale,/run/current-system/sw/share/locale,g \
      -e s,/usr/lib/cinnamon-screensaver,$out/lib,g \
      -e s,/usr/share/cinnamon-screensaver,$out/share,g \
      -e s,/usr/share/iso-flag-png,${iso-flags-png-320x420}/share/iso-flags-png,g \
      {} +
  '';

  preFixup = ''
    # https://github.com/NixOS/nixpkgs/issues/101881
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gnome.caribou}/share"
    )
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/cinnamon-screensaver";
    description = "The Cinnamon screen locker and screensaver program";
    license = [ licenses.gpl2 licenses.lgpl2 ];
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
