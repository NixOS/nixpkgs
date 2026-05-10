{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonPackage rec {
  pname = "thinkpad-scripts";
  version = "4.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "martin-ueding";
    repo = "thinkpad-scripts";
    tag = "v${version}";
    hash = "sha256-foraZWLYV/Rg+TcKy3atAwhXqCBeQeXs+orzWzLqTSE=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    setuptools
  ];

  meta = {
    description = "Screen rotation, docking and other scripts for ThinkPad® X220 and X230 Tablet";
    homepage = "https://github.com/martin-ueding/thinkpad-scripts";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ dawidsowa ];
  };
}
