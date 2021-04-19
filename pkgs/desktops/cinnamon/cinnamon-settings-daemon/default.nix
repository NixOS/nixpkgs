{ fetchFromGitHub
, cinnamon-desktop
, colord
, glib
, gsettings-desktop-schemas
, gtk3
, lcms2
, libcanberra-gtk3
, libgnomekbd
, libnotify
, libxklavier
, wrapGAppsHook
, pkg-config
, pulseaudio
, lib, stdenv
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
, nss
, libgudev
, meson
, ninja
, dbus
, dbus-glib
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-settings-daemon";
  version = "4.8.5";

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
    hash = "sha256-PAWVTjGFs8yKXgNQ2ucDnEDS+n7bp2n3lhGl9gHXfdQ=";
  };

  patches = [
    ./csd-backlight-helper-fix.patch
    ./use-sane-install-dir.patch
  ];

  mesonFlags = [ "-Dc_args=-I${glib.dev}/include/gio-unix-2.0" ];

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
    nss
    libgudev
    dbus
    dbus-glib
  ];

  nativeBuildInputs = [
    meson
    ninja
    wrapGAppsHook
    pkg-config
  ];

  outputs = [ "out" "dev" ];

  postPatch = ''
    sed "s|/usr/share/zoneinfo|${tzdata}/share/zoneinfo|g" -i plugins/datetime/system-timezone.h
  '';

  # So the polkit policy can reference /run/current-system/sw/bin/cinnamon-settings-daemon/csd-backlight-helper
  postFixup = ''
    mkdir -p $out/bin/cinnamon-settings-daemon
    ln -s $out/libexec/csd-backlight-helper $out/bin/cinnamon-settings-daemon/csd-backlight-helper
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/cinnamon-settings-daemon";
    description = "The settings daemon for the Cinnamon desktop";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.mkg20001 ];
  };
}
