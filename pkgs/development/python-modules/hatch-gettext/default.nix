{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # Build system
  hatchling,
  # Dependencies
  rich,
}:

buildPythonPackage (finalAttrs: {
  pname = "hatch-gettext";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "damonlynch";
    repo = "hatch-gettext";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hdYwDKRzv3iRoKUtPssOL2t4iPPsK+wlSydbMOeFyUs=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    rich
  ];

  pythonImportsCheck = [
    "hatch_gettext"
  ];

  meta = {
    description = "Hatch build hook plugin for GNU gettext";
    homepage = "https://github.com/damonlynch/hatch-gettext";
    changelog = "https://github.com/damonlynch/hatch-gettext/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ philipdb ];
  };
})
