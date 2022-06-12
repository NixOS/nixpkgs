{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ansi";
  version = "0.3.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tehmaze";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-2gu2Dba3LOjMhbCCZrBqzlOor5KqDYThhe8OP8J3O2M=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ansi.colour"
    "ansi.color"
  ];

  meta = with lib; {
    description = "ANSI cursor movement and graphics";
    homepage = "https://github.com/tehmaze/ansi/";
    license = licenses.mit;
  };
}
