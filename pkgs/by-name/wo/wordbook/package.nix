{
  lib,
  fetchFromGitHub,
  python3,
  meson,
  ninja,
  pkg-config,
  libadwaita,
  espeak-ng,
  gobject-introspection,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wordbook";
  version = "0.4.0";
  pyproject = false; # Built with meson

  src = fetchFromGitHub {
    owner = "fushinari";
    repo = "Wordbook";
    rev = "refs/tags/${version}";
    hash = "sha256-oiAXSDJJtlV6EIHzi+jFv+Ym1XHCMLx9DN1YRiXZNzc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = [
    libadwaita
  ];

  dependencies = with python3.pkgs; [
    pygobject3
    wn
  ];

  # prevent double wrapping
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      --prefix PATH ":" "${lib.makeBinPath [ espeak-ng ]}"
      "''${gappsWrapperArgs[@]}"
    )
  '';

  meta = {
    description = "Offline English-English dictionary application built for GNOME";
    mainProgram = "wordbook";
    homepage = "https://github.com/fushinari/Wordbook";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
  };
}
