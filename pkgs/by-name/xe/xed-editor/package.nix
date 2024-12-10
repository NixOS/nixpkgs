{
  stdenv,
  lib,
  fetchFromGitHub,
  libxml2,
  libpeas,
  glib,
  gtk3,
  gtksourceview4,
  gspell,
  xapp,
  pkg-config,
  python3,
  meson,
  ninja,
  versionCheckHook,
  wrapGAppsHook3,
  intltool,
  itstool,
}:

stdenv.mkDerivation rec {
  pname = "xed-editor";
  version = "3.6.6";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "xed";
    rev = version;
    hash = "sha256-Lpdv8mX3GDzXH1FGGdmgK9b8P3EY7ETuEhGfSwc6IIE=";
  };

  patches = [
    # We patch gobject-introspection and meson to store absolute paths to libraries in typelibs
    # but that requires the install_dir is an absolute path.
    ./correct-gir-lib-path.patch
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    intltool
    itstool
    ninja
    python3
    versionCheckHook
    wrapGAppsHook3
  ];

  buildInputs = [
    libxml2
    glib
    gtk3
    gtksourceview4
    libpeas
    gspell
    xapp
  ];

  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/xed";

  meta = with lib; {
    description = "Light weight text editor from Linux Mint";
    homepage = "https://github.com/linuxmint/xed";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      tu-maurice
      bobby285271
    ];
    mainProgram = "xed";
  };
}
