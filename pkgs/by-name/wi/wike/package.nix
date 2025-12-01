{
  lib,
  fetchFromGitHub,
  python3Packages,
  meson,
  ninja,
  pkg-config,
  appstream-glib,
  desktop-file-utils,
  gobject-introspection,
  wrapGAppsHook4,
  glib,
  gtk4,
  librsvg,
  libadwaita,
  glib-networking,
  webkitgtk_6_0,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "wike";
  version = "3.1.3";
  pyproject = false; # built with meson

  src = fetchFromGitHub {
    owner = "hugolabe";
    repo = "Wike";
    tag = version;
    hash = "sha256-+N9yhzIErFc0z/2JqEtit02GZKqo11viGCLoyQxtxBU=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    appstream-glib
    desktop-file-utils
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    librsvg
    libadwaita
    glib-networking
    webkitgtk_6_0
  ];

  dependencies = with python3Packages; [
    requests
    pygobject3
  ];

  # prevent double wrapping
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")

    patchShebangs --update $out/share/wike/wike-sp
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Wikipedia Reader for the GNOME Desktop";
    homepage = "https://github.com/hugolabe/Wike";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ samalws ];
    teams = [ lib.teams.gnome-circle ];
    mainProgram = "wike";
  };
}
