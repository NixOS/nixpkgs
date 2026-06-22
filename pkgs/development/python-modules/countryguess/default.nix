{
  lib,
  buildPythonPackage,
  fetchFromCodeberg,
  pytest-mock,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "countryguess";
  version = "0.4.9";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "plotski";
    repo = "countryguess";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RlOOao6aU3MylghDyOeg3poYQw+0UhljN79/ZBLjq24=";
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
})
