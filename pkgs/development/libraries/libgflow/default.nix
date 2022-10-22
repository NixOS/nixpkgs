{stdenv, lib, vala, meson, ninja, pkg-config, fetchFromGitea, gobject-introspection, glib, gtk3}:

stdenv.mkDerivation rec {
  pname = "libgflow";
  version = "1.0.4";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "devdoc"; # demo app

  src = fetchFromGitea {
    domain = "notabug.org";
    owner = "grindhold";
    repo = "libgtkflow";
    rev = "gflow_${version}";
    hash = "sha256-JoVq7U5JQ3pRxptR7igWFw7lcBTsgr3aVXxayLqhyFo=";
  };

  nativeBuildInputs = [
    vala
    meson
    ninja
    pkg-config
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    glib
  ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  mesonFlags = [
    "-Denable_valadoc=true"
    "-Denable_gtk3=false"
    "-Denable_gtk4=false"
  ];

  meta = with lib; {
    description = "Flow graph widget for GTK 3";
    homepage = "https://notabug.org/grindhold/libgtkflow";
    maintainers = with maintainers; [ grindhold ];
    license = licenses.lgpl3Plus;
    platforms = platforms.unix;
  };
}
