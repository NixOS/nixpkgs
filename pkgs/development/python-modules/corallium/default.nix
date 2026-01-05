{
  beartype,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  poetry-core,
  pydantic,
  python,
  rich,
  tomli,
}:
buildPythonPackage rec {
  pname = "corallium";
  version = "2.1.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = pname;
    tag = version;
    hash = "sha256-0P8qmX+1zigL4jaA4TTuqAzFkyhQUfdGmPLxkFnT0qE=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    beartype
    pydantic
    rich
  ]
  ++ lib.optionals (python.pythonOlder "3.11") [
    tomli
  ];

  meta = with lib; {
    description = "Shared functionality for calcipy-ecosystem";
    homepage = "https://corallium.kyleking.me";
    license = licenses.mit;
    maintainers = with maintainers; [ yajo ];
  };
}
