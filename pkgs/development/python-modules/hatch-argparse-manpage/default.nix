{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # Build system
  hatchling,
  # Dependencies
  argparse-manpage,
  rich,
}:

buildPythonPackage (finalAttrs: {
  pname = "hatch-argparse-manpage";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "damonlynch";
    repo = "hatch-argparse-manpage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wkMLbbOkIRO83byUTJRYAS7uTYc2weL/viH1fI8xYh0=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    argparse-manpage
    rich
  ];

  pythonImportsCheck = [
    "hatch_argparse_manpage"
  ];

  meta = {
    description = "Hatch build hook plugin to automatically generate manual pages";
    homepage = "https://github.com/damonlynch/hatch-argparse-manpage";
    changelog = "https://github.com/damonlynch/hatch-argparse-manpage/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ philipdb ];
  };
})
