{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, importlib-metadata
, pip
, pytestCheckHook
, pythonOlder
, setuptools
, testpath
, tomli
, zipp
}:

buildPythonPackage rec {
  pname = "pep517";
  version = "0.12.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kxN42T0RspjPUR3WNM9epMskmijvhBYLMkfumvtOirA=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    tomli
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
    zipp
  ];

  checkInputs = [
    pip
    pytestCheckHook
    setuptools
    testpath
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--flake8" ""
  '';

  disabledTestPaths = [
    # Tests require network access
    "tests/test_meta.py"
  ];

  disabledTests = [
    "test_issue_104"
    "test_setup_py"
  ];

  pythonImportsCheck = [
    "pep517"
  ];

  meta = with lib; {
    description = "Wrappers to build Python packages using PEP 517 hooks";
    license = licenses.mit;
    homepage = "https://github.com/pypa/pep517";
    maintainers = with maintainers; [ ];
  };
}
