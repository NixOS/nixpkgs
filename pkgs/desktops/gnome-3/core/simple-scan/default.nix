{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, itstool, python3, wrapGAppsHook
, cairo, gdk_pixbuf, colord, glib, gtk, gusb, packagekit, libwebp
, libxml2, sane-backends, vala, gnome3, gobject-introspection }:

stdenv.mkDerivation rec {
  name = "simple-scan-${version}";
  version = "3.30.2";

  src = fetchurl {
    url = "mirror://gnome/sources/simple-scan/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0dknvdjlnxrp9nxd3yr8wyjc4kv94nwglss8pr6rfvl4hnlly53i";
  };

  buildInputs = [
    cairo gdk_pixbuf colord glib gnome3.defaultIconTheme gusb
    gtk libwebp packagekit sane-backends vala
  ];
  nativeBuildInputs = [
    meson ninja gettext itstool pkgconfig python3 wrapGAppsHook libxml2
    # For setup hook
    gobject-introspection
  ];

  postPatch = ''
    patchShebangs data/meson_compile_gschema.py
  '';

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "simple-scan";
    };
  };

  meta = with stdenv.lib; {
    description = "Simple scanning utility";
    longDescription = ''
      A really easy way to scan both documents and photos. You can crop out the
      bad parts of a photo and rotate it if it is the wrong way round. You can
      print your scans, export them to pdf, or save them in a range of image
      formats. Basically a frontend for SANE - which is the same backend as
      XSANE uses. This means that all existing scanners will work and the
      interface is well tested.
    '';
    homepage = https://gitlab.gnome.org/GNOME/simple-scan;
    license = licenses.gpl3Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
