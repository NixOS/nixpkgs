{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  cryptography,
  python-dateutil,
  six,
  pbr,
  coverage,
  oslotest,
  stestr,
}:

buildPythonPackage rec {
  pname = "pyghmi";
  version = "1.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jPfGPKQkHLyapGWJ0o05e79pPlw0UWNJeHHJgb+MdFQ=";
  };

  build-system = [
    pbr
    setuptools
  ];

  nativeCheckInputs = [
    coverage
    oslotest
    stestr
  ];

  dependencies = [
    cryptography
    python-dateutil
    six
    pbr
  ];

  pythonImportsCheck = [ "pyghmi" ];

  checkPhase = ''
    runHook preCheck
    stestr run
    runHook postCheck
  '';

  meta = {
    description = "Pure Python (mostly IPMI) server management library";
    homepage = "https://opendev.org/x/pyghmi/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ codgician ];
  };
}
