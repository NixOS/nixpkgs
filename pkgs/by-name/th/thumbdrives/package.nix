{
  lib,
  python3,
  fetchFromSourcehut,
  gtk3,
  libhandy_0,
  gobject-introspection,
  meson,
  pkg-config,
  ninja,
  gettext,
  glib,
  desktop-file-utils,
  wrapGAppsHook3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "thumbdrives";
  version = "0.3.2";

  pyproject = false;

  src = fetchFromSourcehut {
    owner = "~martijnbraam";
    repo = "thumbdrives";
    rev = finalAttrs.version;
    hash = "sha256-Mh3NSEYscnzw6kjR9m0XbTygj07cIQwdyLcdLpfKi3Y=";
  };

  postPatch = ''
    patchShebangs build-aux/meson
  '';

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    gettext
    glib
    gtk3
    desktop-file-utils
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    libhandy_0
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    pyxdg
  ];

  meta = {
    description = "USB mass storage emulator for Linux handhelds";
    homepage = "https://sr.ht/~martijnbraam/thumbdrives/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      chuangzhu
      Luflosi
    ];
    platforms = lib.platforms.linux;
  };
})
