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
, wrapGAppsHook4
, libmediaart
, gobject-introspection
, gnome-online-accounts
, grilo
, grilo-plugins
, pkg-config
, gtk4
, pango
, glib
, desktop-file-utils
, appstream-glib
, itstool
, gnome
, gst_all_1
, libsoup_3
, libadwaita
, gsettings-desktop-schemas
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gnome-music";
  version = "44.0";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "m9GqyVcuYkcgJKaVDYOubyhr4zzZx3fz1E+hbQOPHVE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    itstool
    pkg-config
    libxml2
    wrapGAppsHook4
    desktop-file-utils
    appstream-glib
    gobject-introspection
  ];

  buildInputs = [
    gtk4
    pango
    glib
    libmediaart
    gnome-online-accounts
    gobject-introspection
    gdk-pixbuf
    python3
    grilo
    grilo-plugins
    libnotify
    libsoup_3
    libadwaita
    gsettings-desktop-schemas
    tracker
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
  ]);

  pythonPath = with python3.pkgs; [
    pycairo
    dbus-python
    pygobject3
  ];

  # Prevent double wrapping, let the Python wrapper use the args in preFixup.
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
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
    platforms = platforms.unix;
  };
}
