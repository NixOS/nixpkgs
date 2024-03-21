{ buildPythonPackage
, fetchPypi

# build-system
, setuptools

# dependencies
, pyopenssl
, requests
, six
}:

buildPythonPackage rec {
  pname = "paypalrestsdk";
  version = "1.13.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2sI2SSqawSYKdgAUouVqs4sJ2BQylbXollRTWbYf7dY=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pyopenssl
    requests
    six
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [
    "paypalrestsdk"
  ];

  meta = {
    homepage = "https://developer.paypal.com/";
    description = "Python APIs to create, process and manage payment";
    license = "PayPal SDK License";
  };
}
