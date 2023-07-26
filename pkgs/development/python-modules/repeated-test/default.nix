{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "repeated-test";
  version = "2.3.3";
  format = "pyproject";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    pname = "repeated_test";
    inherit version;
    hash = "sha256-3YPU8SL9rud5s0pnwwH5TJk1MXsDhdkDnZp/Oj6sgXs=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "repeated_test"
  ];

  meta = with lib; {
    description = "Unittest-compatible framework for repeating a test function over many fixtures";
    homepage = "https://github.com/epsy/repeated_test";
    changelog = "https://github.com/epsy/repeated_test/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ tjni ];
  };
}
