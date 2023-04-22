{ fetchFromGitHub
, cinnamon-desktop
, cinnamon-translations
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
, lib
, stdenv
, systemd
, upower
, dconf
, cups
, polkit
, librsvg
, libwacom
, xorg
, fontconfig
, tzdata
, nss
, libgudev
, meson
, ninja
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-settings-daemon";
  version = "5.6.2";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-IqYfHMjKe7gVsM6HgihQMNkcXSYBOft1lamXOLa1Y8k=";
  };

  patches = [
    ./csd-backlight-helper-fix.patch
    ./use-sane-install-dir.patch
  ];

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
    systemd
    upower
    dconf
    cups
    polkit
    librsvg
    libwacom
    xorg.libXext
    xorg.libX11
    xorg.libXi
    xorg.libXfixes
    fontconfig
    nss
    libgudev
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

  # use locales from cinnamon-translations (not using --localedir because datadir is used)
  postInstall = ''
    ln -s ${cinnamon-translations}/share/locale $out/share/locale
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
    maintainers = teams.cinnamon.members;
  };
}
