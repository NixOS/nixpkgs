{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pycryptodomex
}:

buildPythonPackage rec {
  pname = "pyctr";
  version = "0.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SnCps5nzrl+dkbloRbjhaOGDzKOsi8OHX2JXgoJ/XG0=";
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
