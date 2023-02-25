{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "nocaselist";
  version = "1.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SPBn+MuEEkXzTQMSC8G6mQDxOxnLUbzGx77gF/fIdNo=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "nocaselist"
  ];

  meta = with lib; {
    description = "A case-insensitive list for Python";
    homepage = "https://github.com/pywbem/nocaselist";
    changelog = "https://github.com/pywbem/nocaselist/blob/${version}/docs/changes.rst";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ freezeboy ];
  };
}
