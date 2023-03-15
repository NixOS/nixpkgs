{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, toml
, pyyaml
, packaging
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dparse";
  version = "0.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1FJVvaIfmYvH3fKv1eYlBbphNHVrotQqhMVrCCZhTf4=";
  };

  propagatedBuildInputs = [
    toml
    pyyaml
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dparse"
  ];

  disabledTests = [
    # requires unpackaged dependency pipenv
    "test_update_pipfile"
  ];

  meta = with lib; {
    description = "A parser for Python dependency files";
    homepage = "https://github.com/pyupio/dparse";
    license = licenses.mit;
    maintainers = with maintainers; [ thomasdesr ];
  };
}
