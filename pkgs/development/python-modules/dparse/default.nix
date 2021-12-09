{ lib
, buildPythonPackage
, fetchFromGitHub
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

  src = fetchFromGitHub {
     owner = "pyupio";
     repo = "dparse";
     rev = "0.5.1";
     sha256 = "0c0ws1v4f3vwv4w1rlhq0n8bdrpd7lc3a6h901d6giqcif9kqp8x";
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
