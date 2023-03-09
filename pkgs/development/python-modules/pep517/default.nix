{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, tomli
, pythonOlder
, importlib-metadata
, zipp
, pytestCheckHook
, setuptools
, testpath
, mock
, pip
}:

buildPythonPackage rec {
  pname = "pep517";
  version = "0.13.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rmmSfFwXK+Gt2SA3JtS4TPPrrR7c1fcfzcdG5m6Cn1k=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    tomli
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata zipp
  ];

  nativeCheckInputs = [
    pytestCheckHook
    setuptools
    testpath
    mock
    pip
  ];

  disabledTests = [
    "test_setup_py"
    "test_issue_104"
  ];

  preCheck = ''
    rm pytest.ini # wants flake8
    rm tests/test_meta.py # wants to run pip
  '';

  meta = {
    description = "Wrappers to build Python packages using PEP 517 hooks";
    license = lib.licenses.mit;
    homepage = "https://github.com/pypa/pep517";
  };
}
