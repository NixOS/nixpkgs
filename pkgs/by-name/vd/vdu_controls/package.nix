{
  lib,
  python3,
  fetchFromGitHub,
  fetchpatch,
  qt6,
  copyDesktopItems,
  installShellFiles,
  ddcutil,
  brightnessctl,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "vdu_controls";
  version = "2.6.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "digitaltrails";
    repo = "vdu_controls";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7ca7eNj67F9RCV99pZLxYD9J12zqzonw4t/Z8xUhvdw=";
  };

  build-system = [
    python3.pkgs.wheel
    python3.pkgs.setuptools
  ];

  postPatch = ''
    substituteInPlace \
      sample-scripts/vlux_meter.py \
      src/vdu_controls/constants.py \
      src/vdu_controls/app_locale.py \
      packaging/vdu_controls.wrapper \
      --replace-fail /usr/share $out/share
  '';

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    copyDesktopItems
    installShellFiles
  ];

  desktopItems = "vdu_controls.desktop";

  postInstall = ''
    install -Dm066 src/vdu_controls/resources/icons/app/vdu_controls.svg $out/share/icons/hicolor/scalable/apps/vdu_controls.svg
    installManPage docs/_build/man/vdu_controls.1
    mkdir -p $out/${python3.sitePackages}/vdu_controls/resources
    cp -r src/vdu_controls/resources $out/${python3.sitePackages}/vdu_controls
    cp -r sample-scripts $out/share/vdu_controls
    cp -r translations $out/share/vdu_controls
  '';

  dependencies = [
    python3.pkgs.pyqt6
    python3.pkgs.pyudev
    python3.pkgs.pyserial
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
    ddcutil
    brightnessctl
  ];

  preFixup = ''
    makeWrapperArgs+=(
      "''${qtWrapperArgs[@]}"
      --prefix PATH : ${
        lib.makeBinPath [
          ddcutil
          brightnessctl
        ]
      }
    )
  '';

  meta = {
    description = "VDU controls - a control panel for monitor brightness/contrast";
    homepage = "https://github.com/digitaltrails/vdu_controls";
    license = lib.licenses.gpl3Only;
    mainProgram = "vdu_controls";
  };
})
