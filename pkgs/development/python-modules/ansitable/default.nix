{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  colored,
  pytestCheckHook,
  numpy,
  pandas,
}:

buildPythonPackage rec {
  pname = "ansitable";
  version = "0.11.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-A7seYrOgTvO9npvE0vRbKlkiGqi1P6Q/mKXfWKQz4aE=";
  };

  build-system = [ setuptools ];

  dependencies = [ colored ];

  pythonImportsCheck = [ "ansitable" ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
    pandas
  ];

  meta = {
    description = "Quick and easy display of tabular data and matrices with optional ANSI color and borders";
    homepage = "https://pypi.org/project/ansitable/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      djacu
      a-camarillo
    ];
  };
}
