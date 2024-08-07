{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  vala,
  gi-docgen,
  glib,
  gtk4,
  libadwaita,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "libpanel";
  version = "1.7.1";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/libpanel/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-e2D9g/D1fn2A8nw6tAs2nViPk1RroT3mGVMh5C09FCk=";
  };

  strictDeps = true;

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    gi-docgen
    gtk4 # gtk4-update-icon-cache
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  mesonFlags = [ (lib.mesonBool "install-examples" true) ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript { packageName = pname; };
  };

  meta = with lib; {
    description = "Dock/panel library for GTK 4";
    mainProgram = "libpanel-example";
    homepage = "https://gitlab.gnome.org/GNOME/libpanel";
    license = licenses.lgpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
