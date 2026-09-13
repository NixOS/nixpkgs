{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  anytree,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pickpack";
  version = "2.0.0-1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anafvana";
    repo = "pickpack";
    rev = "v${version}";
    hash = "sha256-C3Nh8+9TEmTTGACC/LF/GWlVvgNMsOCkWviijku+gu0=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    anytree
  ];

  pythonImportsCheck = [
    "pickpack"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Curses-based (and pick-based) interactive picker for the terminal. Now covering trees also";
    homepage = "https://github.com/anafvana/pickpack";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
