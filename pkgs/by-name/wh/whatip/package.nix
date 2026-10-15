{
  lib,
  fetchFromGitLab,
  python3,
  meson,
  ninja,
  pkg-config,
  glib,
  gtk4,
  libadwaita,
  librsvg,
  blueprint-compiler,
  gobject-introspection,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "whatip";
  version = "1.2";

  pyproject = false;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GabMus";
    repo = "whatip";
    rev = finalAttrs.version;
    hash = "sha256-gt/NKgnCpRoVmLvEJJq2geng4miM2g+YhXYEOm5pPTA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    blueprint-compiler
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk4
    librsvg
    libadwaita
  ];

  propagatedBuildInputs = with python3.pkgs; [
    netaddr
    requests
    pygobject3
  ];

  meta = {
    description = "Info on your IP";
    mainProgram = "whatip";
    homepage = "https://gitlab.gnome.org/GabMus/whatip";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
  };
})
