{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, webob
}:

buildPythonPackage rec {
  pname = "bugsnag";
  version = "4.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PT6XaKz3QFAEhCmS7jXKK7xxscNlpbhGpCKQIRuSt6U=";
  };

  propagatedBuildInputs = [
    webob
  ];

  pythonImportsCheck = [
    "bugsnag"
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Automatic error monitoring for Python applications";
    homepage = "https://github.com/bugsnag/bugsnag-python";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
