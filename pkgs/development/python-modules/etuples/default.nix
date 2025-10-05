{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cons,
  multipledispatch,
  py,
  pytestCheckHook,
  pytest-html,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "etuples";
  version = "0.3.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pythological";
    repo = "etuples";
    tag = "v${version}";
    hash = "sha256-h5MLj1z3qZiUXcNIDtUIbV5zeyTzxerbSezFD5Q27n0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    cons
    multipledispatch
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

  pythonImportsCheck = [ "etuples" ];

  meta = with lib; {
    description = "Python S-expression emulation using tuple-like objects";
    homepage = "https://github.com/pythological/etuples";
    changelog = "https://github.com/pythological/etuples/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ Etjean ];
  };
}
