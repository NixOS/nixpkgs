{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "netaddr";
  version = "0.9.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-e0b6mxotcf1d6eSjeE7zOXAKU6CMgEDwi69fEZTaASg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "netaddr"
  ];

  meta = with lib; {
    description = "A network address manipulation library for Python";
    homepage = "https://netaddr.readthedocs.io/";
    downloadPage = "https://github.com/netaddr/netaddr/releases";
    changelog = "https://github.com/netaddr/netaddr/blob/${version}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
