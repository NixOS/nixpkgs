{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  hatch-vcs,
  click,
  numpy,
  uhi,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "histoprint";
  version = "2.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "histoprint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yYPFGFrw4JV5Abu2kbNcwsnVtCNvnqhCl4cbX95wzQ8=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    click
    numpy
    uhi
  ];

  checkInputs = [ pytestCheckHook ];

  meta = {
    description = "Pretty print histograms to the console";
    mainProgram = "histoprint";
    homepage = "https://github.com/scikit-hep/histoprint";
    changelog = "https://github.com/scikit-hep/histoprint/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
