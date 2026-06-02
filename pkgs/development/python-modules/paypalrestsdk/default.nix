{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pyopenssl,
  requests,
  six,
}:

buildPythonPackage rec {
  pname = "paypalrestsdk";
  version = "1.13.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2sI2SSqawSYKdgAUouVqs4sJ2BQylbXollRTWbYf7dY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyopenssl
    requests
    six
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "paypalrestsdk" ];

  meta = {
    description = "Python APIs to create, process and manage payment";
    homepage = "https://github.com/paypal/PayPal-Python-SDK";
    changelog = "https://github.com/paypal/PayPal-Python-SDK/blob/master/CHANGELOG.md";
    license = {
      fullName = "PayPal SDK License";
      url = "https://github.com/paypal/PayPal-Python-SDK/blob/master/LICENSE";
    };
    maintainers = [ ];
  };
}
