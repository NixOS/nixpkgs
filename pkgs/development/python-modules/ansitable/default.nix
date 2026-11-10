{
  lib,
  buildPythonPackage,
  colored,
  fetchPypi,
  hatchling,
  numpy,
  pandas,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ansitable";
  version = "0.11.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-A7seYrOgTvO9npvE0vRbKlkiGqi1P6Q/mKXfWKQz4aE=";
  };

  build-system = [ hatchling ];

  dependencies = [ colored ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
    pandas
  ];

  pythonImportsCheck = [ "ansitable" ];

  meta = {
    description = "Quick and easy display of tabular data and matrices with optional ANSI color and borders";
    homepage = "https://github.com/petercorke/ansitable";
    changelog = "";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      djacu
      a-camarillo
    ];
  };
}
