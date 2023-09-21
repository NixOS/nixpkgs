{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pytest-mock
}:

buildPythonPackage rec {
  pname = "pykka";
  version = "4.0.0";
  format = "pyproject";
  disabled = pythonOlder "3.6.1";

  src = fetchFromGitHub {
    owner = "jodal";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-xFEEv4UAKv/H//7OIBSb9juwmuH4xWd6BKBXaX2GwFU=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  meta = with lib; {
    homepage = "https://www.pykka.org/";
    description = "A Python implementation of the actor model";
    changelog = "https://github.com/jodal/pykka/blob/v${version}/docs/changes.rst";
    maintainers = with maintainers; [ marsam ];
    license = licenses.asl20;
  };
}
