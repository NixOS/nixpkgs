{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonPackage rec {
  pname = "win2xcur";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "quantum5";
    repo = "win2xcur";
    rev = "v${version}";
    hash = "sha256-OjLj+QYg8YOJzDq3Y6/uyEXlNWbPm8VA/b1yP9jT6Jo=";
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
