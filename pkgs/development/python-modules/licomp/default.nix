{
  lib,
  buildPythonPackage,
  fetchFromGitea,

  # build-system
  setuptools,

  # dependencies
  pyyaml,

  # tests
  pytestCheckHook,
  jsonschema,
}:

buildPythonPackage (finalAttrs: {
  pname = "licomp";
  version = "0.5.22";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "software-compliance-org";
    repo = "licomp";
    tag = finalAttrs.version;
    hash = "sha256-yZZfWinXdMmF/FQQ3+MwHRypK5Xz2EEMruJLCAtl/6Q=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    jsonschema
  ];

  pythonImportsCheck = [
    "licomp"
  ];

  meta = {
    description = "License Compatibility - Generalised API for use in license compatibility";
    homepage = "https://codeberg.org/software-compliance-org/licomp";
    license = with lib.licenses; [
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
