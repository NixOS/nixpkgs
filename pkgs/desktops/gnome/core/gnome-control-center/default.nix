{ fetchurl
, lib
, stdenv
, substituteAll
, accountsservice
, adwaita-icon-theme
, colord
, colord-gtk4
, cups
, docbook-xsl-nons
, fontconfig
, gdk-pixbuf
, gettext
, glib
, glib-networking
, gcr
, glibc
, gnome-bluetooth
, gnome-color-manager
, gnome-desktop
, gnome-online-accounts
, gnome-settings-daemon
, gnome
, gsettings-desktop-schemas
, gsound
, gtk4
, ibus
, libgnomekbd
, libgtop
, libgudev
, libadwaita
, libkrb5
, libpulseaudio
, libpwquality
, librsvg
, libsecret
, libwacom
, libxml2
, libxslt
, meson
, modemmanager
, mutter
, networkmanager
, networkmanagerapplet
, libnma-gtk4
, ninja
, pkg-config
, polkit
, python3
, samba
, shared-mime-info
, sound-theme-freedesktop
, tracker
, tracker-miners
, tzdata
, udisks2
, upower
, libepoxy
, gnome-user-share
, gnome-remote-desktop
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gnome-control-center";
  version = "43.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-cfmrzgWDyCKTLWvyxP9KPDxA3RjUMgUAPoMf7s62dQs=";
  };

  patches = [
    (substituteAll {
      src = ./paths.patch;
      gcm = gnome-color-manager;
      inherit glibc libgnomekbd tzdata;
      inherit cups networkmanagerapplet;
    })
  ];

  nativeBuildInputs = [
    docbook-xsl-nons
    gettext
    libxslt
    meson
    ninja
    pkg-config
    python3
    shared-mime-info
    wrapGAppsHook
  ];

  buildInputs = [
    accountsservice
    adwaita-icon-theme
    colord
    colord-gtk4
    libepoxy
    fontconfig
    gdk-pixbuf
    glib
    glib-networking
    gcr
    gnome-bluetooth
    gnome-desktop
    gnome-online-accounts
    gnome-remote-desktop # optional, sharing panel
    gnome-settings-daemon
    gnome-user-share # optional, sharing panel
    gsettings-desktop-schemas
    gsound
    gtk4
    ibus
    libgtop
    libgudev
    libadwaita
    libkrb5
    libnma-gtk4
    libpulseaudio
    libpwquality
    librsvg
    libsecret
    libwacom
    libxml2
    modemmanager
    mutter # schemas for the keybindings
    networkmanager
    polkit
    samba
    tracker
    tracker-miners # for search locations dialog
    udisks2
    upower
  ];

  preConfigure = ''
    # For ITS rules
    addToSearchPath "XDG_DATA_DIRS" "${polkit.out}/share"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${sound-theme-freedesktop}/share"
      # Thumbnailers (for setting user profile pictures)
      --prefix XDG_DATA_DIRS : "${gdk-pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"
      # WM keyboard shortcuts
      --prefix XDG_DATA_DIRS : "${mutter}/share"
    )
    for i in $out/share/applications/*; do
      substituteInPlace $i --replace "Exec=gnome-control-center" "Exec=$out/bin/gnome-control-center"
    done
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    description = "Utilities to configure the GNOME desktop";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
