{ lib
, buildPythonPackage
, fetchFromGitHub
, toolz
, cons
, multipledispatch
, etuples
, logical-unification
, py
, pytestCheckHook
, pytest-html
}:

buildPythonPackage rec {
  pname = "minikanren";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "pythological";
    repo = "kanren";
    rev = "5aa9b1734cbb3fe072a7c72b46e1b72a174d28ac";
    hash = "sha256-daAtREgm91634Q0mc0/WZivDiyZHC7TIRoGRo8hMnGE=";
  };

  propagatedBuildInputs = [
    toolz
    cons
    multipledispatch
    etuples
    logical-unification
  ];

  nativeCheckInputs = [
    py
    pytestCheckHook
    pytest-html
  ];

  pytestFlagsArray = [
    "--html=testing-report.html"
    "--self-contained-html"
  ];

  pythonImportsCheck = [ "kanren" ];

  meta = with lib; {
    description = "Relational programming in Python";
    homepage = "https://github.com/pythological/kanren";
    changelog = "https://github.com/pythological/kanren/releases";
    license = licenses.bsd3;
    maintainers = with maintainers; [ Etjean ];
  };
}
