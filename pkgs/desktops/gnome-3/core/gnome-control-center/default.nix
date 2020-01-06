{ fetchurl
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
, docbook_xsl
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
, gnome-session
, gnome-settings-daemon
, gnome3
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
, ninja
, pkgconfig
, polkit
, python3
, samba
, shared-mime-info
, sound-theme-freedesktop
, tracker
, tzdata
, udisks2
, upower
, vino
, gnome-user-share
, gnome-remote-desktop
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gnome-control-center";
  version = "3.34.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "054igagvmyzpaa5nwzz98gv7bk7l5dwp6g813707132si3szlpx8";
  };

  nativeBuildInputs = [
    docbook_xsl
    gettext
    libxslt
    meson
    ninja
    pkgconfig
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
    networkmanagerapplet
    polkit
    samba
    tracker
    udisks2
    upower
    vino
  ];

  patches = [
    (substituteAll {
      src = ./paths.patch;
      gcm = gnome-color-manager;
      gnome_desktop = gnome-desktop;
      inherit glibc libgnomekbd tzdata;
      inherit cups networkmanagerapplet;
    })
  ];

  postPatch = ''
    chmod +x build-aux/meson/meson_post_install.py # patchShebangs requires executable file
    patchShebangs build-aux/meson/meson_post_install.py
  '';

  mesonFlags = [
    "-Dgnome_session_libexecdir=${gnome-session}/libexec"
  ];

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
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Utilities to configure the GNOME desktop";
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
