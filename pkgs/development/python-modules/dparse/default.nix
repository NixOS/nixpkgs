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
  version = "0.5.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-w0iZSh9ByF9mTY9aR0QmR7xOIsWvWxsm7ymv8Ppd3c0=";
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
