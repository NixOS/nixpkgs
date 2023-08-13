{ lib, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, gettext
, itstool
, python3
, wrapGAppsHook
, cairo
, gdk-pixbuf
, colord
, glib
, gtk3
, gusb
, packagekit
, libhandy
, libwebp
, libxml2
, sane-backends
, vala
, gnome
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "simple-scan";
  version = "44.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-Obhw/Ub0R/dH6uzC3yYEnvdzGFCZ8OE8Z1ZWJk3ZjpU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    itstool
    pkg-config
    python3
    wrapGAppsHook
    libxml2
    gobject-introspection # For setup hook
    vala
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    colord
    glib
    gusb
    gtk3
    libhandy
    libwebp
    packagekit
    sane-backends
  ];

  postPatch = ''
    patchShebangs data/meson_compile_gschema.py
  '';

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "simple-scan";
    };
  };

  meta = with lib; {
    description = "Simple scanning utility";
    longDescription = ''
      A really easy way to scan both documents and photos. You can crop out the
      bad parts of a photo and rotate it if it is the wrong way round. You can
      print your scans, export them to pdf, or save them in a range of image
      formats. Basically a frontend for SANE - which is the same backend as
      XSANE uses. This means that all existing scanners will work and the
      interface is well tested.
    '';
    homepage = "https://gitlab.gnome.org/GNOME/simple-scan";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
