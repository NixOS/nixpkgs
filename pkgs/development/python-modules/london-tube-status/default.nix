{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  pytestCheckHook,
  requests-mock,
}:

buildPythonPackage rec {
  pname = "london-tube-status";
<<<<<<< HEAD
  version = "0.7";
=======
  version = "0.6.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robmarkcole";
    repo = "London-tube-status";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-0uDCrF3abx94X47LQxgALirSF/spJPVD91G2WqXaDVs=";
=======
    hash = "sha256-bdkGDVWcyJXH21qGrdJnSa4IW2kJskFTJ5ye6M6eOz4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  # Tests are currently broken
  # https://github.com/robmarkcole/London-tube-status/issues/7
  doCheck = false;

  pythonImportsCheck = [
    "london_tube_status"
  ];

  meta = {
    description = "Parse London tube data from TFL into a dictionary";
    homepage = "https://github.com/robmarkcole/London-tube-status";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
