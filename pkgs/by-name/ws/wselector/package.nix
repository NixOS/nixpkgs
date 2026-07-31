{
  fetchFromGitHub,
  gdk-pixbuf,
  glib,
  gobject-introspection,
  gtk4,
  lib,
  libadwaita,
  pango,
  python3Packages,
  wrapGAppsHook4,
  xdg-utils,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "wselector";
  version = "0.2.0";
  __structuredAttrs = true;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Cookiiieee";
    repo = "WSelector";
    rev = "v${finalAttrs.version}";
    hash = "sha256-crsPE71pG8kdeO6NDyqxCENxX/Jgmr3rPRU4dwlIpgg=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  nativeBuildInputs = [
    wrapGAppsHook4
    gobject-introspection
  ];

  buildInputs = [
    gtk4
    libadwaita
    glib
    gdk-pixbuf
    pango
    xdg-utils
  ];

  dependencies = with python3Packages; [
    pygobject3
    requests
    beautifulsoup4
    psutil
  ];

  meta = {
    description = "Modern GTK4/Libadwaita wallpaper browser for Wallhaven.cc";
    homepage = "https://github.com/Cookiiieee/WSelector";
    changelog = "https://github.com/Cookiiieee/WSelector/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ kyleb ];
    mainProgram = "wselector";
    platforms = lib.platforms.linux;
  };
})
