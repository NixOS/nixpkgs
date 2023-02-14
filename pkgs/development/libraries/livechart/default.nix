{lib, stdenv, fetchFromGitHub, vala, meson, ninja, pkg-config, gtk3, glib, libgee}:

stdenv.mkDerivation rec {
  pname = "livechart";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "lcallarec";
    repo = "live-chart";
    rev = version;
    hash = "sha256:0kiiih7ynjzppbks3zl3m3xj9gnl3slyf6n0ixyfr0j8nvgrwxgc";
  };

  nativeBuildInputs = [
    vala
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    gtk3
    glib
    libgee
  ];

  meta = with lib; {
    description = "Graph plotting widget for GTK 3";
    homepage = "https://github.com/lcallarec/live-chart";
    maintainers = with maintainers; [ grindhold ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
