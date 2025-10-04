{
  lib,
  buildPythonPackage,
  fetchFromGitea,
  pytest-mock,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "countryguess";
  version = "0.4.7";
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "plotski";
    repo = "countryguess";
    tag = "v${version}";
    hash = "sha256-yZyEOFXwbaYAIDl6LoHkwoqlhVzqShY8ZXPasB6unQ8=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "countryguess" ];

  meta = {
    description = "Fuzzy lookup of country information";
    homepage = "https://codeberg.org/plotski/countryguess";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
}
