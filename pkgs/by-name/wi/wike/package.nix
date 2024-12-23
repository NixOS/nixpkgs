{
  lib,
  fetchFromGitHub,
  python3,
  meson,
  ninja,
  pkg-config,
  pkgsCross,
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
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wike";
  version = "3.1.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "hugolabe";
    repo = "Wike";
    rev = version;
    hash = "sha256-Wx0jMO9a2K22zIU0B++0ZtPzLi+PrsJ5Sw8Sb8BODdU=";
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

  propagatedBuildInputs = with python3.pkgs; [
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
    tests.cross = pkgsCross.aarch64-multiplatform.wike;
  };

  meta = with lib; {
    description = "Wikipedia Reader for the GNOME Desktop";
    homepage = "https://github.com/hugolabe/Wike";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ samalws ] ++ lib.teams.gnome-circle.members;
    mainProgram = "wike";
  };
}
