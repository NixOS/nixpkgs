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
  version = "4.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9q6Cp/reUJJ3XGMT9BV+4z5AxJdP8izfzgjOpS84/Tc=";
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
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
