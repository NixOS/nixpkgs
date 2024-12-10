{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
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
  libstartup_notification,
  gettext,
  gobject-introspection,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "libwnck";
  version = "43.0";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];
  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "kFvNuFhH1rj4hh5WswzW3GHq5n7O9M2ZSp+SWiaiwf4=";
  };

  patches = [
    # bamfdaemon crashes with libwnck3 43.0
    # https://bugs.launchpad.net/ubuntu/+source/libwnck3/+bug/1990263
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/libwnck/-/commit/6ceb684442eb26e3bdb8a38bf52264ad55f96a7b.patch";
      sha256 = "/1wCnElCrZB7XTDW/l3dxMKZ9czGnukbGu4/aQStoXE=";
    })
  ];

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
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "Library to manage X windows and workspaces (via pagers, tasklists, etc.)";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ liff ];
  };
}
