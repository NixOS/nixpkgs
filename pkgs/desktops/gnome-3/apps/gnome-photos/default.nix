{ stdenv, gettext, fetchurl, libxml2, libgdata
, pkgconfig, gtk3, glib, tracker, tracker-miners
, itstool, gegl, babl, libdazzle, gfbgraph, grilo-plugins
, grilo, gnome-online-accounts
, desktop-file-utils, wrapGAppsHook
, gnome3, gdk-pixbuf, gexiv2, geocode-glib
, dleyna-renderer, dbus, meson, ninja, python3, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  pname = "gnome-photos";
  version = "3.32.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0nxa2jz1g73wypdsj19r4plf4hfkhs9mpl7gbhsiyqp1rkn84ahn";
  };

  # doCheck = true;

  nativeBuildInputs = [
    pkgconfig gettext itstool meson ninja libxml2
    desktop-file-utils wrapGAppsHook python3
  ];
  buildInputs = [
    gtk3 glib gegl babl libgdata libdazzle
    gsettings-desktop-schemas
    gdk-pixbuf gnome3.adwaita-icon-theme
    gfbgraph grilo-plugins grilo
    gnome-online-accounts tracker
    gexiv2 geocode-glib dleyna-renderer
    tracker-miners # For 'org.freedesktop.Tracker.Miner.Files' GSettings schema
    dbus
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
    homepage = https://wiki.gnome.org/Apps/Photos;
    description = "Access, organize and share your photos";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
