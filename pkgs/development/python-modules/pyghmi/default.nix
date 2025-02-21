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
  version = "1.5.76";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nJEL9x/+fZT/vpAKL5qVLXYVPcMvUXT9WSEvHzOrGZU=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  nativeCheckInputs = [
    coverage
    oslotest
    stestr
  ];

  propagatedBuildInputs = [
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

  meta = with lib; {
    description = "A pure Python (mostly IPMI) server management library";
    homepage = "https://opendev.org/x/pyghmi/";
    license = licenses.asl20;
    maintainers = with maintainers; [ codgician ];
  };
}
