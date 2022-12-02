{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "parameter-expansion-patched";
  version = "0.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/128ifveWC8zNlYtGWtxB3HpK6p7bVk1ahSwhaC2dAs=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "parameter_expansion"
  ];

  meta = with lib; {
    description = "POSIX parameter expansion in Python";
    homepage = "https://github.com/nexB/parameter_expansion_patched";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
