{
  lib,
  pkg-config,
  python3Packages,
  meson,
  ninja,
  appstream-glib,
  desktop-file-utils,
  glib,
  gtk3,
  gobject-introspection,
  wrapGAppsHook3,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "tuhi";
  version = "0.6";

  format = "other";

  src = fetchFromGitHub {
    owner = "tuhiproject";
    repo = "tuhi";
    rev = version;
    sha256 = "sha256-NwyG2KhOrAKRewgmU23OMO0+A9SjkQZsDL4SGnLVCvo=";
  };

  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    appstream-glib
    desktop-file-utils
    wrapGAppsHook3
    gobject-introspection
  ];
  buildInputs = [
    gtk3
    glib
  ];
  nativeCheckInputs = with python3Packages; [
    flake8
    pytest
  ];
  propagatedBuildInputs = with python3Packages; [
    svgwrite
    pyxdg
    pycairo
    pygobject3
    setuptools-scm
  ];

  strictDeps = false;
  preConfigure = ''
    substituteInPlace meson_install.sh \
      --replace "/usr/bin/env sh" "sh"
  '';
  postFixup = ''
    wrapPythonProgramsIn $out/libexec "$out $pythonPath"
  '';

  meta = with lib; {
    description = "DBus daemon to access Wacom SmartPad devices";
    mainProgram = "tuhi";
    homepage = "https://github.com/tuhiproject/tuhi";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lammermann ];
  };
}
