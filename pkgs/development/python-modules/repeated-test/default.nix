{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "repeated-test";
  version = "2.3.1";
  format = "pyproject";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    pname = "repeated_test";
    inherit version;
    hash = "sha256-TbVyQA7EjCSwo6qfDksbE8IU1ElkSCABEUBWy5j1KJc=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    six
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
    license = licenses.mit;
    maintainers = with maintainers; [ tjni ];
  };
}
