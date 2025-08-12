{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "merge-args";
  version = "0.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kwpolska";
    repo = "merge_args";
    tag = "v${version}";
    hash = "sha256-e98nmg3OsSgUiLgqs4Z4O1vx/NdegX50BadFCzw9qtY=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "merge_args" ];

  meta = {
    description = "Merge signatures of two functions with Advanced Python Hackery";
    homepage = "https://github.com/Kwpolska/merge_args";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ matrixman ];
  };
}
