{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "goocanvas";
  version = "3.0.0";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/goocanvas/${lib.versions.majorMinor finalAttrs.version}/goocanvas-${finalAttrs.version}.tar.xz";
    sha256 = "06j05g2lmwvklmv51xsb7gm7rszcarhm01sal41jfp0qzrbpa2k7";
  };

  patches = [
    # This broke due to the introduction of anubis
    /*
      (fetchpatch {
        url = "https://gitlab.gnome.org/Archive/goocanvas/-/commit/d025d0eeae1c5266063bdc1476dbdff121bcfa57.patch";
        hash = "sha256-9uqqC1uKZF9TDz5dfDTKSRCmjEiuvqkLnZ9w6U+q2TI=";
      })
    */
    ./gcc14-fix.patch
  ];

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
      attrPath = "${finalAttrs.pname}${lib.versions.major finalAttrs.version}";
      packageName = finalAttrs.pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    description = "Canvas widget for GTK based on the the Cairo 2D library";
    homepage = "https://gitlab.gnome.org/Archive/goocanvas";
    license = lib.licenses.lgpl2Plus; # The license contains the "or later" clause
    maintainers = with lib.maintainers; [
      bobby285271
      pandapip1
    ];
    platforms = lib.platforms.unix;
  };
})
