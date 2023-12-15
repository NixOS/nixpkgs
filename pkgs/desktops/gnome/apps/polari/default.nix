{ stdenv
, lib
, itstool
, fetchurl
, gdk-pixbuf
, telepathy-glib
, gjs
, meson
, ninja
, gettext
, telepathy-idle
, libxml2
, desktop-file-utils
, pkg-config
, gtk4
, libadwaita
, gtk3
, glib
, libsecret
, libsoup_3
, webkitgtk_4_1
, gobject-introspection
, appstream-glib
, gnome
, wrapGAppsHook4
, telepathy-logger
, gspell
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "polari";
  version = "45.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "nbfdwJSqhVfxkXfhZMQti+Fn9UckuScTC3YhyCnB1KE=";
  };

  patches = [
    # Upstream runs the thumbnailer by passing it to gjs.
    # If we wrap it in a shell script, gjs can no longer run it.
    # Let’s change the code to run the script directly by making it executable and having gjs in shebang.
    ./make-thumbnailer-wrappable.patch
  ];

  propagatedUserEnvPkgs = [
    telepathy-idle
    telepathy-logger
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    itstool
    gettext
    wrapGAppsHook4
    libxml2
    desktop-file-utils
    gobject-introspection
    appstream-glib
  ];

  buildInputs = [
    gtk4
    libadwaita
    gtk3 # for thumbnailer
    glib
    gsettings-desktop-schemas
    telepathy-glib
    telepathy-logger
    gjs
    gspell
    gdk-pixbuf
    libsecret
    libsoup_3
    webkitgtk_4_1 # for thumbnailer
  ];

  postFixup = ''
    wrapGApp "$out/share/polari/thumbnailer.js"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Polari";
    description = "IRC chat client designed to integrate with the GNOME desktop";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
