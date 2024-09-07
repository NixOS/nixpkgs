{stdenv, lib, vala, meson, ninja, pkg-config, fetchFromGitea, gobject-introspection, glib, gtk3, libgflow}:

stdenv.mkDerivation rec {
  pname = "libgtkflow3";
  version = "1.0.6";

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "devdoc"; # demo app

  src = fetchFromGitea {
    domain = "notabug.org";
    owner = "grindhold";
    repo = "libgtkflow";
    rev = "gtkflow3_${version}";
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
    libgflow
  ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  mesonFlags = [
    "-Denable_valadoc=true"
    "-Denable_gtk4=false"
    "-Denable_gflow=false"
  ];

  postPatch = ''
    rm -r libgflow
  '';

  meta = with lib; {
    description = "Flow graph widget for GTK 3";
    homepage = "https://notabug.org/grindhold/libgtkflow";
    maintainers = with maintainers; [ grindhold ];
    license = licenses.lgpl3Plus;
    platforms = platforms.unix;
  };
}
