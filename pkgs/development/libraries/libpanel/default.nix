{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, vala
, gobject-introspection
, gi-docgen
, glib
, libadwaita
, gtk4
, gnome
}:

stdenv.mkDerivation rec {
  pname = "libpanel";
  version = "1.0.1";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/libpanel/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "hBtqtx6wcv1lIAI+H3Gqx/8lDGbq37sXyVXaa/QeIwY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gobject-introspection
    gi-docgen
  ];

  buildInputs = [
    glib
    libadwaita
    gtk4
  ];

  mesonFlags = [
    "-Dinstall-examples=true"
  ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "Dock/panel library for GTK 4";
    homepage = "https://gitlab.gnome.org/chergert/libpanel";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
