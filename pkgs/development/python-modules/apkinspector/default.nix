{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "apkinspector";
  version = "1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bB/WeCRnYOdfg4bm9Nloa2QMxr2IJW8IZd+svUno4N0=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  # Tests are not available
  # https://github.com/erev0s/apkInspector/issues/21
  doCheck = false;

  pythonImportsCheck = [
    "apkInspector"
  ];

  meta = with lib; {
    description = "Module designed to provide detailed insights into the zip structure of APK files";
    homepage = "https://github.com/erev0s/apkInspector";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
