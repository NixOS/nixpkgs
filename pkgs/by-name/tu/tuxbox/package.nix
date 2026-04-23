{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "tuxbox";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AndyCappDev";
    repo = "tuxbox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hBk4KhLNMgk8bFCZPQMtQlJ1/RB9qcL4kiF+eb3n4LU=";
  };

  patches = [
    ./Broaden-pgrep-patterns-to-detect-driver-on-NixOS.patch
  ];

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    bleak
    evdev
    pyserial
    pyside6
  ];

  meta = {
    changelog = "https://github.com/AndyCappDev/tuxbox/releases/tag/${finalAttrs.version}";
    description = "Linux driver for all TourBox models - Native feel with USB, Bluetooth, haptics and graphical configuration GUI";
    homepage = "https://github.com/AndyCappDev/tuxbox";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ CompileTime ];
    mainProgram = "tuxbox";
  };
})
