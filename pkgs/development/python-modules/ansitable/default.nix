{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  colored,
  pytestCheckHook,
  numpy,
  pandas,
}:

buildPythonPackage rec {
  pname = "ansitable";
  version = "0.11.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XUjXVs9/ETlbbtvYz8YJqCsP1BFajqQKQfSM+Rvm4O0=";
  };

  build-system = [ setuptools ];

  dependencies = [ colored ];

  pythonImportsCheck = [ "ansitable" ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
    pandas
  ];

  meta = with lib; {
    description = "Quick and easy display of tabular data and matrices with optional ANSI color and borders";
    homepage = "https://pypi.org/project/ansitable/";
    license = licenses.mit;
    maintainers = with maintainers; [
      djacu
      a-camarillo
    ];
  };
}
