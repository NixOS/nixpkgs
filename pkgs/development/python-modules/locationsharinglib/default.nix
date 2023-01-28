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
  version = "4.1.8";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-69NzKSWpuU0Riwlj6cFC4h/shc/83e1mpq++zxDqftY=";
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
       --replace "coloredlogs>=15.0.1" "coloredlogs"
  '';

  checkPhase = ''
    runHook preCheck
    # Only coverage no real unit tests
    nosetests
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
