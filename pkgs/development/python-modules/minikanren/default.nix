{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  toolz,
  cons,
  multipledispatch,
  etuples,
  logical-unification,
  py,
  pytestCheckHook,
  pytest-html,
}:

buildPythonPackage {
  pname = "minikanren";
  version = "1.0.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pythological";
    repo = "kanren";
    tag = "v${version}";
    hash = "sha256-lCQ0mKT99zK5A74uoo/9bP+eFdm3MC43Fh8+P2krXrs=";
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

  pytestFlags = [
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
