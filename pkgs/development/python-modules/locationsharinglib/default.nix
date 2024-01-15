{ lib
, betamax
, buildPythonPackage
, cachetools
, coloredlogs
, emoji
, fetchPypi
, nose
, pythonOlder
, pytz
, requests
}:

buildPythonPackage rec {
  pname = "locationsharinglib";
  version = "5.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ar5/gyDnby0aceqqHe8lTQaHafOub+IPKglmct4xEGM=";
  };

  propagatedBuildInputs = [
    coloredlogs
    requests
    cachetools
    pytz
  ];

  nativeCheckInputs = [
    betamax
    emoji
    nose
  ];

  postPatch = ''
    # Tests requirements want to pull in multiple modules which we don't need
    substituteInPlace setup.py \
      --replace "tests_require=test_requirements" "tests_require=[]"
    substituteInPlace requirements.txt \
      --replace "coloredlogs>=15.0.1" "coloredlogs" \
      --replace "pytz>=2023.3" "pytz"
  '';

  checkPhase = ''
    runHook preCheck
    # Only coverage no real unit tests
    nosetests
    runHook postCheck
  '';

  pythonImportsCheck = [
    "locationsharinglib"
  ];

  meta = with lib; {
    description = "Python package to retrieve coordinates from a Google account";
    homepage = "https://locationsharinglib.readthedocs.io/";
    changelog = "https://github.com/costastf/locationsharinglib/blob/${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
