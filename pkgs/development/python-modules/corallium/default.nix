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
  pyproject = true;

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
  ];

  meta = {
    description = "Shared functionality for calcipy-ecosystem";
    homepage = "https://corallium.kyleking.me";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yajo ];
  };
}
