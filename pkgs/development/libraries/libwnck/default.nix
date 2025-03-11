{
  stdenv,
  lib,
  fetchurl,
  meson,
  mesonEmulatorHook,
  ninja,
  pkg-config,
  gtk-doc,
  docbook_xsl,
  docbook_xml_dtd_412,
  libX11,
  glib,
  gtk3,
  pango,
  cairo,
  libXres,
  libXi,
  libstartup_notification,
  gettext,
  gobject-introspection,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "libwnck";
  version = "43.2";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];
  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/libwnck/${lib.versions.major version}/libwnck-${version}.tar.xz";
    sha256 = "VadETsH7uVwIbUCWc4jyMbXAu8jP+qCGv5KQrkSeUdU=";
  };

  nativeBuildInputs =
    [
      meson
      ninja
      pkg-config
      gettext
      gobject-introspection
      gtk-doc
      docbook_xsl
      docbook_xml_dtd_412
    ]
    ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      mesonEmulatorHook
    ];

  buildInputs = [
    libX11
    libstartup_notification
    pango
    cairo
    libXres
    libXi
  ];

  propagatedBuildInputs = [
    glib
    gtk3
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "libwnck";
    };
  };

  meta = with lib; {
    description = "Library to manage X windows and workspaces (via pagers, tasklists, etc.)";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ liff ];
  };
}
