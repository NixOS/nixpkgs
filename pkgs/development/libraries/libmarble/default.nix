{ lib
, stdenv
, desktop-file-utils
, fetchFromGitLab
, glib
, gobject-introspection
, gtk3
, meson
, ninja
, pkg-config
, vala
}:

stdenv.mkDerivation rec {
  pname = "libmarble";
  version = "1.3.0";

  strictDeps = true;

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "raggesilver";
    repo = "marble";
    rev = "v${version}";
    hash = "sha256-jAoRGE4fRJKj7J7gIfRVtvGBXh7pEDuc/NAEgCB3Pqo=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    glib
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
    gtk3
  ];

  buildInputs = [
    gtk3
  ];

  meta = {
    description = "Paulo Queiroz's personal GTK 4 library";
    homepage = "https://gitlab.com/raggesilver/marble";
    maintainers = [ lib.maintainers.anselmschueler ];
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
