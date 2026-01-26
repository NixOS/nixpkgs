{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonPackage rec {
  pname = "win2xcur";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "quantum5";
    repo = "win2xcur";
    rev = "v${version}";
    hash = "sha256-uG9yrH1BvdGyFosGBXLNB7lr0w7r89MWhW4gCVS+s1w=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    numpy
    wand
  ];

  pythonImportsCheck = [
    "win2xcur.main.win2xcur"
    "win2xcur.main.x2wincur"
  ];

  meta = {
    description = "Tools that convert cursors between the Windows (*.cur, *.ani) and Xcursor format";
    homepage = "https://github.com/quantum5/win2xcur";
    changelog = "https://github.com/quantum5/win2xcur/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ teatwig ];
  };
}
