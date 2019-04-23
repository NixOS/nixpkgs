{ stdenv, gettext, fetchurl, libxml2, libgdata
, pkgconfig, gtk3, glib, tracker, tracker-miners
, itstool, gegl, babl, libdazzle, gfbgraph, grilo-plugins
, grilo, gnome-online-accounts
, desktop-file-utils, wrapGAppsHook
, gnome3, gdk_pixbuf, gexiv2, geocode-glib
, dleyna-renderer, dbus, meson, ninja, python3 }:

let
  pname = "gnome-photos";
  version = "3.32.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "160vqmcqvyzby27wd2lzwzgbfl6jxxk7phhnqh9498r3clr73haj";
  };

  # doCheck = true;

  nativeBuildInputs = [
    pkgconfig gettext itstool meson ninja libxml2
    desktop-file-utils wrapGAppsHook python3
  ];
  buildInputs = [
    gtk3 glib gegl babl libgdata libdazzle
    gnome3.gsettings-desktop-schemas
    gdk_pixbuf gnome3.adwaita-icon-theme
    gfbgraph grilo-plugins grilo
    gnome-online-accounts tracker
    gexiv2 geocode-glib dleyna-renderer
    tracker-miners # For 'org.freedesktop.Tracker.Miner.Files' GSettings schema
    dbus
  ];

  mesonFlags = [
    "--buildtype=plain" # don't do any git commands
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
