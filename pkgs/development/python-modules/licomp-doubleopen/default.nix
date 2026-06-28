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
  pname = "licomp-doubleopen";
  version = "0.1.5";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hesa";
    repo = "licomp-doubleopen";
    tag = finalAttrs.version;
    hash = "sha256-ju+Ewp5q3bzanLeldtE7NSSlfLpMe6muM4ZlpFgBDh0=";
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
    "licomp_doubleopen"
  ];

  meta = {
    description = "Licomp implementation of Double Open Project's license classifications";
    homepage = "https://github.com/hesa/licomp-doubleopen";
    changelog = "https://github.com/hesa/licomp-doubleopen/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      cc-by-30
      cc-by-40
      cc0
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
