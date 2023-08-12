{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "nocaselist";
  version = "1.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UnKyMuCCRmlqsm/g670ouJidrJ7lcytQJklQMjtRPSM=";
  };

  propagatedBuildInputs = [
    six
  ];

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
