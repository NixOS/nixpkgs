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
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anafvana";
    repo = "pickpack";
    rev = "v${version}";
    hash = "sha256-IUIs+Cgl2fvjSougyVSzhmY2SeEYL2T2ODrBWBg3zZM=";
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
