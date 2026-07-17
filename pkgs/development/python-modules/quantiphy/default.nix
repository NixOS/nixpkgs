{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  inform,
  parametrize-from-file,
  setuptools,
  voluptuous,
  quantiphy-eval,
  rkm-codes,
}:

buildPythonPackage rec {
  pname = "quantiphy";
  version = "2.22.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KenKundert";
    repo = "quantiphy";
    tag = "v${version}";
    hash = "sha256-k6EZJI+7a7qRAKIJkddGTaR3CE9VIbF4J/WXzE9C+7o=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    quantiphy-eval
    rkm-codes
  ];

  nativeCheckInputs = [
    inform
    parametrize-from-file
    pytestCheckHook
    setuptools
    voluptuous
  ];

  pythonImportsCheck = [ "quantiphy" ];

  meta = {
    description = "Module for physical quantities (numbers with units)";
    homepage = "https://quantiphy.readthedocs.io";
    changelog = "https://github.com/KenKundert/quantiphy/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jpetrucciani ];
  };
}
