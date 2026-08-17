{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  hatchling,
  hatch-vcs,
  frictionless,
  jsonschema,
  numpy,
  pandas,
  polars,
  pyarrow,
  pyyaml,
}:

buildPythonPackage (finalAttrs: {
  pname = "camtrap-package";
  version = "0.1.10";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "oscf";
    repo = "camtrap-package";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Zx6S4TAxDWaGty8eHT7+QKlp5Yco7aLpNW8vDTWPTMo=";
  };

  build-system = [
    hatchling
    hatch-vcs
    frictionless
    jsonschema
    numpy
    pandas
    polars
    pyarrow
    pyyaml
  ];

  meta = {
    description = "Toolkit for creating and managing standardized camera trap data packages";
    homepage = "https://gitlab.com/oscf/camtrap-package";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ RossComputerGuy ];
  };
})
