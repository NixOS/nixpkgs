{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  licomp,

  # tests
  pytestCheckHook,
  jsonschema,
}:

buildPythonPackage (finalAttrs: {
  pname = "licomp-osadl";
  version = "0.5.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hesa";
    repo = "licomp-osadl";
    tag = finalAttrs.version;
    hash = "sha256-aWJG7HxYs/8/Km3EpY8/XewCILlgePoKsdJyL8CM6LI=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    licomp
  ];

  nativeCheckInputs = [
    pytestCheckHook
    jsonschema
  ];

  pythonImportsCheck = [
    "licomp_osadl"
  ];

  meta = {
    description = "Implementation of Licomp using OSADL's matrix";
    homepage = "https://github.com/hesa/licomp-osadl";
    changelog = "https://github.com/hesa/licomp-osadl/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      cc-by-40
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
