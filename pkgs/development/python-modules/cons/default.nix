{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  logical-unification,
  py,
  pytestCheckHook,
  pytest-html,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "cons";
  version = "0.4.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pythological";
    repo = "python-cons";
    tag = "v${version}";
    hash = "sha256-BS7lThnv+dxtztvw2aRhQa8yx2cRfrZLiXjcwvZ8QR0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ logical-unification ];

  nativeCheckInputs = [
    py
    pytestCheckHook
    pytest-html
  ];

  pytestFlags = [
    "--html=testing-report.html"
    "--self-contained-html"
  ];

  pythonImportsCheck = [ "cons" ];

  meta = with lib; {
    description = "Implementation of Lisp/Scheme-like cons in Python";
    homepage = "https://github.com/pythological/python-cons";
    changelog = "https://github.com/pythological/python-cons/releases/tag/${src.tag}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Etjean ];
  };
}
