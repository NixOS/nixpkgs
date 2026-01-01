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
<<<<<<< HEAD
  version = "1.6.11";
=======
  version = "1.6.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-yFSpeGcrgO0kwrmbdQ4KPhlqWze2h1g7YdDFNNpoL34=";
=======
    hash = "sha256-UtFTvWt/VX5bKZgAsnM+fzcG5ovh8TR6EKIn58Ohu7g=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
