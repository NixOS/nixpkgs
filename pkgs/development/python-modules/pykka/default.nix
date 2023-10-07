{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pytest-mock
, typing-extensions
}:

buildPythonPackage rec {
  pname = "pykka";
  version = "4.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jodal";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-xFEEv4UAKv/H//7OIBSb9juwmuH4xWd6BKBXaX2GwFU=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  pythonImportsCheck = [
    "pykka"
  ];

  meta = with lib; {
    homepage = "https://www.pykka.org/";
    description = "A Python implementation of the actor model";
    changelog = "https://github.com/jodal/pykka/releases/tag/v${version}";
    maintainers = with maintainers; [ marsam ];
    license = licenses.asl20;
  };
}
