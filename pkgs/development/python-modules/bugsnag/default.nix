{ lib
, blinker
, buildPythonPackage
, fetchPypi
, flask
, pythonOlder
, webob
}:

buildPythonPackage rec {
  pname = "bugsnag";
<<<<<<< HEAD
  version = "4.5.0";
=======
  version = "4.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-R/Fg1OMyR8z0tDUDwqu1Sh3sbvq33AXgBScr3WNm/QY=";
=======
    hash = "sha256-1vtoDmyulfH3YDdMoT9qBFaRd48nnTBCt0iWuQtk3iw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    webob
  ];

  passthru.optional-dependencies = {
    flask = [
      blinker
      flask
    ];
  };

  pythonImportsCheck = [
    "bugsnag"
  ];

  # Module ha no tests
  doCheck = false;

  meta = with lib; {
    description = "Automatic error monitoring for Python applications";
    homepage = "https://github.com/bugsnag/bugsnag-python";
    changelog = "https://github.com/bugsnag/bugsnag-python/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
