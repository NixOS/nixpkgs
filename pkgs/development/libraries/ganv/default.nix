{
  lib,
  stdenv,
  fetchgit,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  graphviz,
  gtk2,
  gtkmm2,
}:

stdenv.mkDerivation rec {
  pname = "ganv";
  version = "1.8.2";

  src = fetchgit {
    url = "https://gitlab.com/drobilla/${pname}.git";
    fetchSubmodules = true;
    rev = "v${version}";
    hash = "sha256-u9U8uMgDAhvriq4xrzqcwDxtaTBhEROB4yyrI5G1PDg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
  ];

  buildInputs = [
    graphviz
    gtk2
    gtkmm2
  ];

  mesonFlags = [
    # Can't figure out how to make meson find 'libintl'
    # for native language support
    (lib.mesonEnable "nls" false)
  ];

  strictDeps = true;

  meta = with lib; {
    description = "Interactive Gtk canvas widget for graph-based interfaces";
    mainProgram = "ganv_bench";
    homepage = "http://drobilla.net";
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
