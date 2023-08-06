{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "decorator";
  version = "5.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Y3mWIRA2tjhe+RQ15PriKYlHL51XH6uoknuoJTrLwzA=";
  };

  pythonImportsCheck = [
    "decorator"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "src/tests/test.py"
  ];

  meta = with lib; {
    homepage = "https://github.com/micheles/decorator";
    description = "Better living through Python with decorators";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
