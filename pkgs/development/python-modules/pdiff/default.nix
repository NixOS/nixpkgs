{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  colorama,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pdiff";
  version = "1.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nkouevda";
    repo = "pdiff";
    rev = "v${version}";
    hash = "sha256-Ek+hWkLfbOnVQvSQ7qSLoZdhXARn5Iz/kmXlFToG2GU=";
  };

  build-system = [ setuptools ];

  dependencies = [ colorama ];

  pythonImportsCheck = [ "pdiff" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Pretty side-by-side diff";
    homepage = "https://github.com/nkouevda/pdiff";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ edmundmiller ];
    mainProgram = "pdiff";
  };
}
