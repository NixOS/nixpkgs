{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  panflute,
  pytestCheckHook,
  pandoc,
  hatchling,
  hatch-vcs,
}:

buildPythonPackage rec {
  pname = "pandoc-latex-environment";
  version = "1.2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chdemko";
    repo = "pandoc-latex-environment";
    tag = version;
    hash = "sha256-uyOqw8YnTljgXkwZOXTXAsnobVSV65EVicohREBNMCY=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [ panflute ];

  pythonImportsCheck = [ "pandoc_latex_environment" ];
  nativeCheckInputs = [
    pytestCheckHook
    pandoc
  ];

  meta = {
    description = "Pandoc filter for adding LaTeX environment on specific div";
    homepage = "https://github.com/chdemko/pandoc-latex-environment";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
