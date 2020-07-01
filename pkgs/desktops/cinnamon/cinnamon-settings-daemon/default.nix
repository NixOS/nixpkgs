{ fetchFromGitHub
, autoconf-archive
, autoreconfHook
, cinnamon-desktop
, colord
, glib
, gsettings-desktop-schemas
, gtk3
, intltool
, lcms2
, libcanberra-gtk3
, libgnomekbd
, libnotify
, libxklavier
, wrapGAppsHook
, pkgconfig
, pulseaudio
, stdenv
, systemd
, upower
, dconf
, cups
, polkit
, librsvg
, libwacom
, xf86_input_wacom
, xorg
, fontconfig
, tzdata
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-settings-daemon";
  version = "4.4.0";

  /* csd-power-manager.c:50:10: fatal error: csd-power-proxy.h: No such file or directory
   #include "csd-power-proxy.h"
            ^~~~~~~~~~~~~~~~~~~
  compilation terminated. */

  # but this occurs only sometimes, so disabling parallel building
  # also see https://github.com/linuxmint/cinnamon-settings-daemon/issues/248
  enableParallelBuilding = false;

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "1h74d68a7hx85vv6ak26b85jq0wr56ps9rzfvqsnxwk81zxw2n7q";
  };

  patches = [
    ./csd-backlight-helper-fix.patch
  ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0"; # TODO: https://github.com/NixOS/nixpkgs/issues/36468

  buildInputs = [
    cinnamon-desktop
    colord
    gtk3
    glib
    gsettings-desktop-schemas
    lcms2
    libcanberra-gtk3
    libgnomekbd
    libnotify
    libxklavier
    pulseaudio
    systemd
    upower
    dconf
    cups
    polkit
    librsvg
    libwacom
    xf86_input_wacom
    xorg.libXext
    xorg.libX11
    xorg.libXi
    xorg.libXtst
    xorg.libXfixes
    fontconfig
  ];

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    wrapGAppsHook
    intltool
    pkgconfig
  ];

  postPatch = ''
    sed "s|/usr/share/zoneinfo|${tzdata}/share/zoneinfo|g" -i plugins/datetime/system-timezone.h
  '';

  # So the polkit policy can reference /run/current-system/sw/bin/cinnamon-settings-daemon/csd-backlight-helper
  postFixup = ''
    mkdir -p $out/bin/cinnamon-settings-daemon
    ln -s $out/libexec/csd-backlight-helper $out/bin/cinnamon-settings-daemon/csd-backlight-helper
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/linuxmint/cinnamon-settings-daemon";
    description = "The settings daemon for the Cinnamon desktop";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.mkg20001 ];
  };
}
