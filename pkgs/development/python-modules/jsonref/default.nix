{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jsonref";
  version = "1.0.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "gazpachoking";
    repo = "jsonref";
    rev = "refs/tags/v${version}";
    hash = "sha256-8p0BmDZGpQ6Dl9rkqRKZKc0doG5pyXpfcVpemmetLhs=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests.py"
  ];

  meta = with lib; {
    description = "An implementation of JSON Reference for Python";
    homepage    = "https://github.com/gazpachoking/jsonref";
    license     = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms   = platforms.all;
  };
}
