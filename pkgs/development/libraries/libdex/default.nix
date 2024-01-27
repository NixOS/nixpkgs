{ stdenv
, lib
, fetchFromGitLab
, gi-docgen
, gobject-introspection
, meson
, ninja
, pkg-config
, vala
, glib
, liburing
, gnome
}:

stdenv.mkDerivation rec {
  pname = "libdex";
  version = "0.4.3";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libdex";
    rev = version;
    sha256 = "0GNlgJgAOE3JGwu/6Zsh4sjFapA7nUcGD3lgZZJ0BfQ=";
  };

  nativeBuildInputs = [
    gi-docgen
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    glib
    liburing
  ];

  mesonFlags = [
    "-Ddocs=true"
  ];

  doCheck = true;

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru.updateScript = gnome.updateScript {
    packageName = "libdex";
  };

  meta = with lib; {
    description = "Library supporting deferred execution for GNOME and GTK";
    homepage = "https://gitlab.gnome.org/GNOME/libdex";
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
  };
}
