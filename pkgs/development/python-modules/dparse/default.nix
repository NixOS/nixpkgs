{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, toml
, pyyaml
, packaging
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dparse";
  version = "0.5.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a1b5f169102e1c894f9a7d5ccf6f9402a836a5d24be80a986c7ce9eaed78f367";
  };

  propagatedBuildInputs = [
    toml
    pyyaml
    packaging
  ];

  checkInputs = [
    pytestCheckHook
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
