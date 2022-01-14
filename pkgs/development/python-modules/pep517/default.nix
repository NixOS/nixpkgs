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
  version = "0.12.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "931378d93d11b298cf511dd634cf5ea4cb249a28ef84160b3247ee9afb4e8ab0";
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
