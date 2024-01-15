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
  version = "0.13.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Gy+i/9OTi7S+/+XWFGy8sr2plqWk2p8xq//Ysk4Hsxc=";
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
