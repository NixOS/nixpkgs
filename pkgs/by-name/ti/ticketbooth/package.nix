{
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  fetchFromGitHub,
  gettext,
  glib,
  gtk4,
  lib,
  libadwaita,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  python3Packages,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication rec {
  pname = "ticketbooth";
  version = "1.2.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "aleiepure";
    repo = "ticketbooth";
    tag = "v${version}";
    hash = "sha256-eP5wYNusBcQLMu4MljfcO9QLY74v5Sb8gITx5dDVLpM=";
  };

  nativeBuildInputs = [
    appstream # for appstreamcli
    blueprint-compiler
    desktop-file-utils # for desktop-file-validate
    gettext # for msgfmt
    glib # for glib-compile-schemas
    gtk4 # for gtk4-update-icon-cache
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  mesonFlags = [
    (lib.mesonBool "prerelease" false)
  ];

  buildInputs = [
    libadwaita
  ];

  dependencies = with python3Packages; [
    pillow
    pygobject3
    tmdbsimple
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/aleiepure/ticketbooth/releases/tag/${src.tag}";
    description = "Keep track of your favorite shows";
    homepage = "https://github.com/aleiepure/ticketbooth";
    license = lib.licenses.gpl3Plus;
    mainProgram = "ticketbooth";
    maintainers = [ lib.maintainers.dotlambda ];
    platforms = lib.platforms.linux;
  };
}
