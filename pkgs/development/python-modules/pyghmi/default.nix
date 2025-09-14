{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
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
  version = "1.6.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-g7QJFreMmO5NWvFmSQWFrHjPHpP6Gy4o31JDHSF2ob8=";
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
