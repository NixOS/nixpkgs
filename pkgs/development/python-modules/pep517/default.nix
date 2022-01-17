{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, tomli
, pythonOlder
, importlib-metadata
, zipp
, pytestCheckHook
, testpath
, mock
, pip
}:

buildPythonPackage rec {
  pname = "pep517";
  version = "0.12.0";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-kxN42T0RspjPUR3WNM9epMskmijvhBYLMkfumvtOirA=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    tomli
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata zipp
  ];

  checkInputs = [
    pytestCheckHook
    testpath
    mock
    pip
  ];

  preCheck = ''
    rm pytest.ini # wants flake8
  '';

  disabledTests = [
    # these import setuptools, which for some reason cannot be found
    "test_issue_104"
    "test_setup_py"
    # skip these instead of removing test_meta.py
    "test_meta_for_this_package"
    "test_classic_package"
    "test_meta_output"
  ];

  meta = {
    description = "Wrappers to build Python packages using PEP 517 hooks";
    license = lib.licenses.mit;
    homepage = "https://github.com/pypa/pep517";
  };
}
