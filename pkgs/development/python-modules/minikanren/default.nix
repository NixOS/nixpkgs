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
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "minikanren";
  version = "1.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pythological";
    repo = "kanren";
    tag = "v${version}";
    hash = "sha256-lCQ0mKT99zK5A74uoo/9bP+eFdm3MC43Fh8+P2krXrs=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
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
    changelog = "https://github.com/pythological/kanren/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ Etjean ];
  };
}
