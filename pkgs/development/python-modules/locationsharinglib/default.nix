{ lib
, betamax
, buildPythonPackage
, cachetools
, coloredlogs
, emoji
, fetchPypi
, nose
, python
, pythonOlder
, pytz
, requests
}:

buildPythonPackage rec {
  pname = "locationsharinglib";
  version = "4.1.6";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "092j8z01nwjqh5zr7aj8mxl1zjd3j2irhrs39dhn47bd6db2a6ij";
  };

  propagatedBuildInputs = [
    coloredlogs
    requests
    cachetools
    pytz
  ];

  checkInputs = [
    betamax
    emoji
    nose
  ];

  postPatch = ''
    # Tests requirements want to pull in multiple modules which we don't need
    substituteInPlace setup.py \
      --replace "tests_require=test_requirements" "tests_require=[]"
  '';

  checkPhase = ''
    runHook preCheck
    # Only coverage no real unit tests
    ${python.interpreter} setup.py nosetests
    runHook postCheck
  '';

  pythonImportsCheck = [ "locationsharinglib" ];

  meta = with lib; {
    description = "Python package to retrieve coordinates from a Google account";
    homepage = "https://locationsharinglib.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
