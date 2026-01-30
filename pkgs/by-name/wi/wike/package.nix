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
  version = "3.2.0";
  pyproject = false; # built with meson

  src = fetchFromGitHub {
    owner = "hugolabe";
    repo = "Wike";
    tag = version;
    hash = "sha256-4J23dUK844ZYQp9LAvaQgN2cnGaPt7eWGOFSAe7WRH8=";
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
  '';
  postFixup = ''
    wrapPythonProgramsIn "$out/share/wike" "$out ''${pythonPath[*]}"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Wikipedia Reader for the GNOME Desktop";
    homepage = "https://hugolabe.github.io/Wike";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ samalws ];
    teams = [ lib.teams.gnome-circle ];
    mainProgram = "wike";
  };
}
