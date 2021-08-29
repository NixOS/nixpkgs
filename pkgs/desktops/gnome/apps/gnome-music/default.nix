{ lib
, meson
, ninja
, gettext
, fetchurl
, gdk-pixbuf
, tracker
, libxml2
, python3
, libnotify
, wrapGAppsHook
, libmediaart
, gobject-introspection
, gnome-online-accounts
, grilo
, grilo-plugins
, pkg-config
, gtk3
, pango
, glib
, desktop-file-utils
, appstream-glib
, itstool
, gnome
, gst_all_1
, libdazzle
, libsoup
, gsettings-desktop-schemas
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gnome-music";
  version = "40.0";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "1djqhd4jccvk352hwxjhiwjgbnv1qnpv450f2c6w6581vcn9pq38";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    itstool
    pkg-config
    libxml2
    wrapGAppsHook
    desktop-file-utils
    appstream-glib
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    pango
    glib
    libmediaart
    gnome-online-accounts
    gobject-introspection
    gdk-pixbuf
    gnome.adwaita-icon-theme
    python3
    grilo
    grilo-plugins
    libnotify
    libdazzle
    libsoup
    gsettings-desktop-schemas
    tracker
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ]);

  propagatedBuildInputs = with python3.pkgs; [
    pycairo
    dbus-python
    pygobject3
  ];


  postPatch = ''
    for f in meson_post_conf.py meson_post_install.py; do
      chmod +x $f
      patchShebangs $f
    done
  '';

  doCheck = false;

  # handle setup hooks better
  strictDeps = false;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Music";
    description = "Music player and management application for the GNOME desktop environment";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
