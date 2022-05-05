{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "parameter-expansion-patched";
  version = "0.3.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/128ifveWC8zNlYtGWtxB3HpK6p7bVk1ahSwhaC2dAs=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "parameter_expansion"
  ];

  meta = with lib; {
    description = "POSIX parameter expansion in Python";
    homepage = "https://github.com/nexB/commoncode";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
