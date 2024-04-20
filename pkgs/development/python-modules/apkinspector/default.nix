{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "apkinspector";
  version = "1.2.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6n5WCQ6V63kbWT6b7t9PEFbrJpxEg1WOE9XV70tHnGA=";
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
    mainProgram = "apkInspector";
    homepage = "https://github.com/erev0s/apkInspector";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
