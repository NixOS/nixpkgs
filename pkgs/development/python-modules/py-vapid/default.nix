{ lib
, buildPythonPackage
, fetchPypi
, flake8
, mock
, nose
, pytest
, cryptography
, pythonOlder
}:

buildPythonPackage rec {
  pname = "py-vapid";
  version = "1.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BmSreJl0LvKyhzl6TUYe9pHtDML1hyBRKNjPYX/9uRk=";
  };

  propagatedBuildInputs = [
    cryptography
  ];

  nativeCheckInputs = [
    flake8
    mock
    nose
    pytest
  ];

  meta = with lib; {
    description = "Library for VAPID header generation";
    homepage = "https://github.com/mozilla-services/vapid";
    license = licenses.mpl20;
    maintainers = with maintainers; [ ];
  };
}
