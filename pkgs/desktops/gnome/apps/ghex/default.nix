{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  gi-docgen,
  meson,
  ninja,
  gnome,
  desktop-file-utils,
  appstream-glib,
  gettext,
  itstool,
  libxml2,
  gtk4,
  libadwaita,
  glib,
  atk,
  gobject-introspection,
  vala,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "ghex";
  version = "46.0";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/ghex/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-ocRvMCDLNYuDIwJds6U5yX2ZSkxG9wH0jtxjV/f7y9E=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    itstool
    meson
    ninja
    pkg-config
    gi-docgen
    gobject-introspection
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    atk
    glib
  ];

  nativeCheckInputs = [
    appstream-glib
    desktop-file-utils
  ];

  mesonFlags =
    [
      "-Dgtk_doc=true"
      "-Dvapi=true"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # mremap does not exist on darwin
      "-Dmmap-buffer-backend=false"
    ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "ghex";
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/ghex";
    description = "Hex editor for GNOME desktop environment";
    mainProgram = "ghex";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
  };
}
