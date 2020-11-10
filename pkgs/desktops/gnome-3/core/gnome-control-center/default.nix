{ fetchurl
, fetchFromGitLab
, fetchpatch
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
, libnma
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
, epoxy
, gnome-user-share
, gnome-remote-desktop
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gnome-control-center";
  version = "3.38.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "09i011hf23s2i4wim43vjys7y4y43cxl3kyvrnrwqvqgc5n0144d";
  };
  # See https://mail.gnome.org/archives/distributor-list/2020-September/msg00001.html
  prePatch = (import ../gvc-with-ucm-prePatch.nix {
    inherit fetchFromGitLab;
  });

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
    libnma
    polkit
    samba
    tracker
    udisks2
    upower
    epoxy
  ];

  patches = [
    (substituteAll {
      src = ./paths.patch;
      gcm = gnome-color-manager;
      gnome_desktop = gnome-desktop;
      inherit glibc libgnomekbd tzdata;
      inherit cups networkmanagerapplet;
    })

    # Fix double free when leaving user accounts panel.
    # https://gitlab.gnome.org/GNOME/gnome-control-center/merge_requests/853
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-control-center/commit/e80b4b5f58f448c5a3d38721f7bba32c413d46e7.patch";
      sha256 = "GffsSU/uNS0Fg2lXbOuD/BrWBT4D2VKgWNGifG0FBUw=";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-control-center/commit/64686cfee330849945f6ff4dcc43393eb1a6e59c.patch";
      sha256 = "4VJU0q6qOtGzd/hmDncckInfEjCkC8+lXmDgxwc4VJU=";
    })
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
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Utilities to configure the GNOME desktop";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
