{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pycryptodomex
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "gpsoauth";
  version = "1.0.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SWYXNYrnzK8P4oK9f7bmOiVdWUQHp8WvhNzIS7Y0msg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pycryptodomex
    requests
  ];

  # upstream tests are not very comprehensive
  doCheck = false;

  pythonImportsCheck = [ "gpsoauth" ];

  meta = with lib; {
    description = "Library for Google Play Services OAuth";
    homepage = "https://github.com/simon-weber/gpsoauth";
    license = licenses.mit;
    maintainers = with maintainers; [ jgillich ];
  };
}
