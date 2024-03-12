{ lib, git, python3, fetchFromGitHub }:

python3.pkgs.buildPythonPackage rec {
  pname = "corallium";
  version = "0.3.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = pname;
    rev = version;
    hash = "sha256-fZzm3o8EwegNG+sYn8lbPz60NMyA/OzGFUf/J/lbGbI=";
  };

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    beartype
    pydantic
    rich
  ] ++ lib.optionals (python3.pythonOlder "3.11") [
    tomli
  ];

  meta = with lib; {
    description = "Shared functionality for calcipy-ecosystem";
    homepage = "https://corallium.kyleking.me";
    license = licenses.mit;
    maintainers = with maintainers; [ yajo ];
  };
}
