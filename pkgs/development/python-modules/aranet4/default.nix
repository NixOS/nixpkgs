{ lib
, bleak
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "aranet4";
  version = "2.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nuxj/rNuwAy1DXaJs0Qrl9GffiZqFkWxT/0TYRxg92s=";
  };

  propagatedBuildInputs = [
    bleak
    requests
  ];

  # https://github.com/Anrijs/Aranet4-Python/issues/31
  doCheck = false;

  pythonImportsCheck = [
    "aranet4"
  ];

  meta = with lib; {
    description = "Module to interact with Aranet4 devices";
    homepage = "https://github.com/Anrijs/Aranet4-Python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
