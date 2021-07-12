{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, toml
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
  version = "0.9.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zqidxah03qpnp6zkg3zd1kmd5f79hhdsfmlc0cldaniy80qddxf";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    toml
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
    rm tests/test_meta.py # wants to run pip
  '';

  meta = {
    description = "Wrappers to build Python packages using PEP 517 hooks";
    license = lib.licenses.mit;
    homepage = "https://github.com/pypa/pep517";
  };
}
