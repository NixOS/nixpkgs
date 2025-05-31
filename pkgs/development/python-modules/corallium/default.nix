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
  version = "0.3.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = pname;
    rev = version;
    hash = "sha256-fZzm3o8EwegNG+sYn8lbPz60NMyA/OzGFUf/J/lbGbI=";
  };

  build-system = [
    poetry-core
  ];

  dependencies =
    [
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
