{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cryptography,
  python-dateutil,
  pbr,
  coverage,
  oslotest,
  stestrCheckHook,
}:

buildPythonPackage rec {
  pname = "pyghmi";
  version = "1.6.18";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lPDS72TvAALtI+D6YoT2rIvxj7J3FMSIw2t8SxZWslw=";
  };

  build-system = [
    pbr
    setuptools
  ];

  dependencies = [
    cryptography
    python-dateutil
  ];

  nativeCheckInputs = [
    coverage
    oslotest
    stestrCheckHook
  ];

  pythonImportsCheck = [ "pyghmi" ];

  meta = {
    description = "Pure Python (mostly IPMI) server management library";
    homepage = "https://opendev.org/x/pyghmi/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ codgician ];
  };
}
