{
  lib,
  python3Packages,
  fetchFromGitHub,
  wrapGAppsHook3,
  gtk3,
  glib,
  gsettings-desktop-schemas,
}:

python3Packages.buildPythonApplication rec {
  pname = "trelby";
  version = "2.4.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trelby";
    repo = "trelby";
    tag = version;
    hash = "sha256-CTasd+YlRHjYUVepZf2RDOuw1p0OdQfJENZamSmXXFw=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gsettings-desktop-schemas
    gtk3
  ];

  dependencies = with python3Packages; [
    lxml
    reportlab
    wxpython
  ];

  postInstall = ''
    install -Dm644 trelby/resources/trelby.desktop $out/share/applications/trelby.desktop

    install -Dm644 trelby/resources/icon256.png $out/share/icons/hicolor/256x256/apps/trelby.png

    substituteInPlace $out/share/applications/trelby.desktop \
      --replace-fail "Icon=trelby256" "Icon=trelby"
  '';

  meta = {
    description = "Free, multiplatform, feature-rich screenwriting program";
    homepage = "https://www.trelby.org";
    downloadPage = "https://github.com/trelby/trelby";
    mainProgram = "trelby";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ isotoxal ];
  };
}
