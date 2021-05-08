{ fetchurl
, fetchpatch
, lib
, stdenv
, substituteAll
, accountsservice
, adwaita-icon-theme
, cheese
, clutter
, clutter-gtk
, colord
, colord-gtk
, cups
, docbook-xsl-nons
, fontconfig
, gdk-pixbuf
, gettext
, glib
, glib-networking
, glibc
, gnome-bluetooth
, gnome-color-manager
, gnome-desktop
, gnome-online-accounts
, gnome-settings-daemon
, gnome
, grilo
, grilo-plugins
, gsettings-desktop-schemas
, gsound
, gtk3
, ibus
, libcanberra-gtk3
, libgnomekbd
, libgtop
, libgudev
, libhandy
, libkrb5
, libpulseaudio
, libpwquality
, librsvg
, libsecret
, libsoup
, libwacom
, libxml2
, libxslt
, meson
, modemmanager
, mutter
, networkmanager
, networkmanagerapplet
, libnma
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
, epoxy
, gnome-user-share
, gnome-remote-desktop
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gnome-control-center";
  version = "40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-zMmlc2UXOFEJrlpZkGwlgkTdh5t1A61ZhM9BZVyzAvE=";
  };

  patches = [
    (substituteAll {
      src = ./paths.patch;
      gcm = gnome-color-manager;
      gnome_desktop = gnome-desktop;
      inherit glibc libgnomekbd tzdata;
      inherit cups networkmanagerapplet;
    })

    # Fix startup assertion in power panel.
    # https://gitlab.gnome.org/GNOME/gnome-control-center/merge_requests/974
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-control-center/commit/9acaa10567c94048657c69538e5d7813f82c4224.patch";
      sha256 = "59GeTPcG2UiVTL4VTS/TP0p0QkAQpm3VgvuAiw64wUU=";
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
    cheese
    clutter
    clutter-gtk
    colord
    colord-gtk
    epoxy
    fontconfig
    gdk-pixbuf
    glib
    glib-networking
    gnome-bluetooth
    gnome-desktop
    gnome-online-accounts
    gnome-remote-desktop # optional, sharing panel
    gnome-settings-daemon
    gnome-user-share # optional, sharing panel
    grilo
    grilo-plugins # for setting wallpaper from Flickr
    gsettings-desktop-schemas
    gsound
    gtk3
    ibus
    libcanberra-gtk3
    libgtop
    libgudev
    libhandy
    libkrb5
    libnma
    libpulseaudio
    libpwquality
    librsvg
    libsecret
    libsoup
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

  postPatch = ''
    chmod +x build-aux/meson/meson_post_install.py # patchShebangs requires executable file
    patchShebangs build-aux/meson/meson_post_install.py
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
