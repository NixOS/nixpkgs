{
  lib,
  buildPythonPackage,
  defusedxml,
  flit-core,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  sphinx,
}:

buildPythonPackage {
  pname = "breathe";
  version = "4.35.0-unstable-2025-01-16";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "breathe-doc";
    repo = "breathe";
    rev = "9711e826e0c46a635715e5814a83cab9dda79b7b"; # 4.35.0 lacks sphinx 7.2+ compat
    hash = "sha256-Ie+8RLWeBgbC4s3TC6ege2YNdfdM0d906BPxB7EOwq8=";
  };

  build-system = [ flit-core ];

  dependencies = [ sphinx ];

  nativeCheckInputs = [
    defusedxml
    pytestCheckHook
  ];

  pythonImportsCheck = [ "breathe" ];

  meta = {
    description = "Sphinx Doxygen renderer";
    mainProgram = "breathe-apidoc";
    homepage = "https://github.com/breathe-doc/breathe";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.sphinx ];
  };
}
