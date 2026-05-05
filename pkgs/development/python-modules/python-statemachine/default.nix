{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
}:

buildPythonPackage rec {
  pname = "python-statemachine";
  version = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "python_statemachine";
    inherit version;
    sha256 = "sha256-kVI/nq1zwdb+zJddXG4L/jY/v1N8XwvzCbzQ+U+UQbI=";
  };

  build-system = [
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
