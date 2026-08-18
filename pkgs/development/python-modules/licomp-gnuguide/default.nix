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
  pname = "licomp-gnuguide";
  version = "0.5.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hesa";
    repo = "licomp-gnuguide";
    tag = finalAttrs.version;
    hash = "sha256-DfjrmEktlTFvKqHIlmM/XeWZ4s24cRtWqs65OLDYZNQ=";
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
    "licomp_gnuguide"
  ];

  meta = {
    description = "Implementation of Licomp using GNU resources";
    homepage = "https://github.com/hesa/licomp-gnuguide";
    changelog = "https://github.com/hesa/licomp-gnuguide/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      cc-by-nd-40 # licomp-gnuguide.png & licomp_gnuguide/data/gnu-quick-guide-licenses.json
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
