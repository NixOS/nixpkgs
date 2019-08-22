{ stdenv
, fetchurl
, babl
, dbus
, desktop-file-utils
, dleyna-renderer
, gdk-pixbuf
, gegl
, geocode-glib
, gettext
, gexiv2
, gfbgraph
, glib
, gnome-online-accounts
, gnome3
, grilo
, grilo-plugins
, gsettings-desktop-schemas
, gtk3
, itstool
, libdazzle
, libgdata
, libxml2
, meson
, ninja
, pkgconfig
, python3
, tracker
, tracker-miners
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gnome-photos";
  version = "3.32.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0nxa2jz1g73wypdsj19r4plf4hfkhs9mpl7gbhsiyqp1rkn84ahn";
  };

  # doCheck = true;

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    itstool
    libxml2
    meson
    ninja
    pkgconfig
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    babl
    dbus
    dleyna-renderer
    gdk-pixbuf
    gegl
    geocode-glib
    gexiv2
    gfbgraph
    glib
    gnome-online-accounts
    gnome3.adwaita-icon-theme
    grilo
    grilo-plugins
    gsettings-desktop-schemas
    gtk3
    libdazzle
    libgdata
    tracker
    tracker-miners # For 'org.freedesktop.Tracker.Miner.Files' GSettings schema
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Access, organize and share your photos";
    homepage = https://wiki.gnome.org/Apps/Photos;
    license = licenses.gpl3Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
