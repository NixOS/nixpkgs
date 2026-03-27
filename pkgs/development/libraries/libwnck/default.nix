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
  libx11,
  glib,
  gtk3,
  pango,
  cairo,
  libxres,
  libxi,
  libstartup_notification,
  gettext,
  gobject-introspection,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "libwnck";
  version = "43.3";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];
  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/libwnck/${lib.versions.major version}/libwnck-${version}.tar.xz";
    sha256 = "avisQajwZ63h08qu0lSoNCO19hrT96Rg/Ky6wuGSvfc=";
  };

  nativeBuildInputs = [
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
    libx11
    libstartup_notification
    pango
    cairo
    libxres
    libxi
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

  meta = {
    description = "Library to manage X windows and workspaces (via pagers, tasklists, etc.)";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ liff ];
  };
}
