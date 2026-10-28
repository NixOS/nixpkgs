{
  lib,
  stdenv,
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
  pname = "licomp-oslc-handbook";
  version = "0.1.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hesa";
    repo = "licomp-oslc-handbook";
    tag = finalAttrs.version;
    hash =
      # Darwin's case-insensitive filesystem produces a different source hash,
      # given a conflict with `licenses` and `LICENSES`
      if stdenv.hostPlatform.isDarwin then
        "sha256-Y01AHnaXWIwqWVS1/QTrGrOqy0ejYC1wwJZ+q2+y0yc="
      else
        "sha256-cgvwFwKlClEPfj9DWvxdBFpnYpdhdXBPsM+qPXxb+SE=";
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
    "licomp_oslc_handbook"
  ];

  meta = {
    description = "Licomp implementation of OSLC-handbook";
    homepage = "https://github.com/hesa/licomp-oslc-handbook";
    changelog = "https://github.com/hesa/licomp-oslc-handbook/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      cc-by-40
      cc-by-sa-40
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
