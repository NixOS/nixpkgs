{ lib, stdenv
, intltool
, fetchurl
, webkitgtk
, pkg-config
, gtk3
, glib
, file
, librsvg
, gnome
, gdk-pixbuf
, python3
, telepathy-glib
, telepathy-farstream
, clutter-gtk
, clutter-gst
, gst_all_1
, cogl
, gnome-online-accounts
, gcr
, libsecret
, folks
, libpulseaudio
, telepathy-mission-control
, telepathy-logger
, libnotify
, clutter
, libsoup
, gnutls
, evolution-data-server
, yelp-xsl
, libcanberra-gtk3
, p11-kit
, farstream
, libtool
, shared-mime-info
, wrapGAppsHook
, itstool
, libxml2
, libxslt
, icu
, libgee
, gsettings-desktop-schemas
, isocodes
, enchant
, libchamplain
, geoclue2
, geocode-glib
, cheese
, libgudev
}:

stdenv.mkDerivation rec {
  pname = "empathy";
  version = "3.25.90";

  src = fetchurl {
    url = "mirror://gnome/sources/empathy/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0sn10fcymc6lyrabk7vx8lpvlaxxkqnmcwj9zdkfa8qf3388k4nc";
  };

  propagatedBuildInputs = [
    (folks.override { telepathySupport = true; })
    telepathy-logger
    evolution-data-server
    telepathy-mission-control
  ];

  nativeBuildInputs = [
    pkg-config
    libtool
    intltool
    itstool
    file
    wrapGAppsHook
    libxml2
    libxslt
    yelp-xsl
    python3
  ];

  buildInputs = [
    gtk3
    glib
    webkitgtk
    icu
    gnome-online-accounts
    telepathy-glib
    clutter-gtk
    clutter-gst
    cogl
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gcr
    libsecret
    libpulseaudio
    gdk-pixbuf
    libnotify
    clutter
    libsoup
    gnutls
    libgee
    p11-kit
    libcanberra-gtk3
    telepathy-farstream
    farstream
    gnome.adwaita-icon-theme
    gsettings-desktop-schemas
    librsvg

    # Spell-checking
    enchant
    isocodes

    # Display maps, location awareness, geocode support
    libchamplain
    geoclue2
    geocode-glib

    # Cheese webcam support, camera monitoring
    cheese
    libgudev
  ];

  enableParallelBuilding = true;

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "empathy";
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Empathy";
    description = "Messaging program which supports text, voice, video chat, and file transfers over many different protocols";
    maintainers = teams.gnome.members;
    license = [ licenses.gpl2 ];
    platforms = platforms.linux;
  };
}
