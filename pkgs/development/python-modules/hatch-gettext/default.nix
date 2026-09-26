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
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "damonlynch";
    repo = "hatch-gettext";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EPyG9RYVdxEvgfHLb18zNCe5Wk6he+QAzxVCsNWu56k=";
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
