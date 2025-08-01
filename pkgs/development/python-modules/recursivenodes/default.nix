{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  numpy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "recursivenodes";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "tisaac";
    repo = "recursivenodes";
    tag = "v${version}";
    hash = "sha256-RThTrYxM4dvTclUZrnne1q1ij9k6aJEeYKTZaxqzs5g=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
  ];

  pythonImportsCheck = [ "recursivenodes" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://tisaac.gitlab.io/recursivenodes/";
    downloadPage = "https://gitlab.com/tisaac/recursivenodes";
    description = "Recursive, parameter-free, explicitly defined interpolation nodes for simplices";
    changelog = "https://gitlab.com/tisaac/recursivenodes/-/releases/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
