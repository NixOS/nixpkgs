{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  gobject-introspection,
  gtk-doc,
  python3,
  cairo,
  gtk3,
  glib,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "goocanvas";
  version = "3.0.0";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/goocanvas/${lib.versions.majorMinor version}/goocanvas-${version}.tar.xz";
    sha256 = "06j05g2lmwvklmv51xsb7gm7rszcarhm01sal41jfp0qzrbpa2k7";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    gobject-introspection
    gtk-doc
    python3
  ];

  buildInputs = [
    cairo
    gtk3
    glib
  ];

  PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_GIRDIR = "$(dev)/share/gir-1.0";
  PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_TYPELIBDIR = "$(out)/lib/girepository-1.0";

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "${pname}${lib.versions.major version}";
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Canvas widget for GTK based on the the Cairo 2D library";
    homepage = "https://gitlab.gnome.org/Archive/goocanvas";
    license = licenses.lgpl2; # https://gitlab.gnome.org/GNOME/goocanvas/-/issues/12
    maintainers = with maintainers; [ bobby285271 ];
    platforms = platforms.unix;
  };
}
