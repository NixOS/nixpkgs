{ lib, stdenv
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
, libnotify
, libxkbfile
, cinnamon-menus
, libgnomekbd
, libxklavier
, networkmanager
, libwacom
, gnome3
, libtool
, wrapGAppsHook
, tzdata
, glibc
, gobject-introspection
, python3
, pam
, accountsservice
, cairo
, xapps
, xorg
, iso-flags-png-320x420
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-screensaver";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "068lh6wcmznfyvny7hx83q2rf4j96b6mv4a5v79y02k9110m7bsm";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/linuxmint/cinnamon-screensaver/pull/349/commits/4a9e5715f406bf2ca1aacddd5fd8f830102a423c.patch";
      sha256 = "0fmkmskry4c88zcw0i8vsmh6q14k3m937hqi77p5xi1p93imr46y";
    })
  ];

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
  ];

  buildInputs = [
    # from meson.build
    gobject-introspection
    gtk3
    glib

    xorg.libXext
    xorg.libXinerama
    xorg.libX11
    xorg.libXrandr

    (python3.withPackages (pp: with pp; [ pygobject3 setproctitle xapp pycairo ]))
    xapps
    pam
    accountsservice
    cairo
    cinnamon-desktop
    cinnamon-common
    libgnomekbd
    gnome3.caribou

    # things
    iso-flags-png-320x420
  ];

  mesonFlags = [
    # TODO: https://github.com/NixOS/nixpkgs/issues/36468
    "-Dc_args=-I${glib.dev}/include/gio-unix-2.0"
  ];

  postPatch = ''
    # cscreensaver hardcodes absolute paths everywhere. Nuke from orbit.
    find . -type f -exec sed -i \
      -e s,/usr/share/locale,/run/current-system/sw/share/locale,g \
      -e s,/usr/lib/cinnamon-screensaver,$out/lib,g \
      -e s,/usr/share/cinnamon-screensaver,$out/share,g \
      -e s,/usr/share/iso-flag-png,${iso-flags-png-320x420}/share/iso-flags-png,g \
      {} +

    sed "s|/usr/share/locale|/run/current-system/sw/share/locale|g" -i ./src/cinnamon-screensaver-main.py
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/cinnamon-screensaver";
    description = "The Cinnamon screen locker and screensaver program";
    license = [ licenses.gpl2 licenses.lgpl2 ];
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
