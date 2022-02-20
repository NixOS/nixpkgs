{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, webob
}:

buildPythonPackage rec {
  pname = "bugsnag";
  version = "4.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NnTn4m9we40Ww2abP7mbz1CtdypZyN2GYBvj8zxhOpI=";
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
