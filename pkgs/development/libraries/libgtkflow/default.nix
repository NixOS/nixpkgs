{stdenv, lib, vala, meson, ninja, pkg-config, fetchFromGitea, gobject-introspection, glib, gtk3}:

stdenv.mkDerivation rec {
  pname = "libgtkflow";
  version = "0.8.0";

  src = fetchFromGitea {
    domain = "notabug.org";
    owner = "grindhold";
    repo = pname;
    rev = version;
    hash = "sha256:1m30rvj5hx3b4cj8lbzrxv4j8lp3hx4jlb8vpf4rh46vc1rdkxpz";
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
