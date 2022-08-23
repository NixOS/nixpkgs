{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "docstring-parser";
  version = "0.14.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rr-";
    repo = "docstring_parser";
    rev = "${version}";
    hash = "sha256-NIijq+QR0panVCGDEQrTlkAvHfIexwS0PxFikglxd74=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "docstring_parser"
  ];

  meta = with lib; {
    description = "Parse Python docstrings in various flavors";
    homepage = "https://github.com/rr-/docstring_parser";
    license = licenses.mit;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
