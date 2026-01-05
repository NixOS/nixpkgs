{
  lib,
  python3Packages,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  blueprint-compiler,
  desktop-file-utils,
  gtk4,
  gst_all_1,
  libsoup_3,
  libadwaita,
  wrapGAppsHook4,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "valuta";
  version = "1.4.2";

  pyproject = false;

  src = fetchFromGitHub {
    owner = "ideveCore";
    repo = "Valuta";
    rev = "v${version}";
    hash = "sha256-1vcjmSXEKy6XTEPV5jiz+ZxzFFUhVnmLK6MDjqoWTHs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    blueprint-compiler
    desktop-file-utils
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    gst_all_1.gstreamer
    libsoup_3
    libadwaita
  ];

  propagatedBuildInputs = with python3Packages; [
    babel
    dbus-python
    pygobject3
  ];

  dontWrapGApps = true;

  # Arguments to be passed to `makeWrapper`, only used by buildPython*
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Simple application for converting currencies, with support for various APIs";
    homepage = "https://github.com/ideveCore/Valuta";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ arthsmn ];
    teams = [ teams.gnome-circle ];
    mainProgram = "currencyconverter";
    platforms = platforms.linux;
  };
}
