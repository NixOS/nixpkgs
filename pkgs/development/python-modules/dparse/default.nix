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
  version = "0.6.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-J7uLS8rv7DmXaXuj9uBrJEcgC6JzwLCFw9ASoEVxtSg=";
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
    changelog = "https://github.com/pyupio/dparse/blob/${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ thomasdesr ];
  };
}
