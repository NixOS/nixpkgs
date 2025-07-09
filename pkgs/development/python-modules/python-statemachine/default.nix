{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
}:

buildPythonPackage rec {
  pname = "python-statemachine";
  version = "2.5.0";
  pyproject = true;

  src = fetchPypi {
    pname = "python_statemachine";
    inherit version;
    sha256 = "0fmrby4c44n8irbf4yw9d4dmf7l13pk7c89sk0mvjc3rwhicv25f";
  };

  nativeBuildInputs = [
    hatchling
  ];

  pythonImportsCheck = [ "statemachine" ];

  meta = with lib; {
    description = "Python finite-state machines made easy";
    homepage = "https://python-statemachine.readthedocs.io/";
    changelog = "https://github.com/fgmacedo/python-statemachine/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bohreromir ];
  };
}
