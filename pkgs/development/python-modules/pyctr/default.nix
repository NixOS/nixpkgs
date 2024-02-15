{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pycryptodomex
}:

buildPythonPackage rec {
  pname = "pyctr";
  version = "0.7.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lpW2pcT5oG7tBUXRj7cTD9hCx51hVhVODq9RxP9GKIg=";
  };

  propagatedBuildInputs = [
    pycryptodomex
  ];

  pythonImportsCheck = [
    "pyctr"
  ];

  meta = with lib; {
    description = "Python library to interact with Nintendo 3DS files";
    homepage = "https://github.com/ihaveamac/pyctr";
    changelog = "https://github.com/ihaveamac/pyctr/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ rileyinman ];
  };
}
