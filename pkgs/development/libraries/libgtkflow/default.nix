{stdenv, lib, vala, meson, ninja, pkg-config, fetchFromGitea, gobject-introspection, glib, gtk3}:

stdenv.mkDerivation rec {
  pname = "libgtkflow";
  version = "0.10.0";

  src = fetchFromGitea {
    domain = "notabug.org";
    owner = "grindhold";
    repo = pname;
    rev = version;
    hash = "sha256-iTOoga94yjGTowQOM/EvHEDOO9Z3UutPGRgEoI1UWkI=";
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

  mesonFlags = [
    "-Denable_valadoc=true"
  ];

  meta = with lib; {
    description = "Flow graph widget for GTK 3";
    homepage = "https://notabug.org/grindhold/libgtkflow";
    maintainers = with maintainers; [ grindhold ];
    license = licenses.lgpl3Plus;
    platforms = platforms.unix;
  };
}
