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
  version = "0.6.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-VwaLthhZsWdsa+sQ85mQbuy0GnW10/vJnQMRBZy2chM=";
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
