{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  gettext,
  gtk-doc,
  gobject-introspection,
  python3,
  gtk3,
  cairo,
  glib,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "goocanvas";
  version = "2.0.4";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/goocanvas/2.0/goocanvas-${version}.tar.xz";
    sha256 = "141fm7mbqib0011zmkv3g8vxcjwa7hypmq71ahdyhnj2sjvy4a67";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    gtk-doc
    python3
    gobject-introspection
  ];
  buildInputs = [
    gtk3
    cairo
    glib
  ];

  # add fedora patch to fix gcc-14 build
  # https://src.fedoraproject.org/rpms/goocanvas2/tree/main
  patches = [
    (fetchpatch {
      name = "goocanvas-2.0.4-Fix-building-with-GCC-14.patch";
      hash = "sha256-9uqqC1uKZF9TDz5dfDTKSRCmjEiuvqkLnZ9w6U+q2TI=";
      url = "https://src.fedoraproject.org/rpms/goocanvas2/raw/e799612a277262a0c6bd03db10a6ee9ca7871b9c/f/goocanvas-2.0.4-Fix-building-with-GCC-14.patch";
    })
  ];

  configureFlags = [
    "--disable-python"
  ];
  PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_GIRDIR = "$(dev)/share/gir-1.0";
  PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_TYPELIBDIR = "$(out)/lib/girepository-1.0";

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "goocanvas${lib.versions.major version}";
      packageName = "goocanvas";
      versionPolicy = "odd-unstable";
      freeze = true;
    };
  };

  meta = with lib; {
    description = "Canvas widget for GTK based on the the Cairo 2D library";
    homepage = "https://gitlab.gnome.org/Archive/goocanvas";
    license = licenses.lgpl2;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
