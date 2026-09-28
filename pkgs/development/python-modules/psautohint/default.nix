{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  fonttools,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-xdist,
  runAllTests ? false,
  psautohint, # for passthru.tests
}:

buildPythonPackage (finalAttrs: {
  pname = "psautohint";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adobe-type-tools";
    repo = "psautohint";
    tag = "v${finalAttrs.version}";
    sha256 = "125nx7accvbk626qlfar90va1995kp9qfrz6a978q4kv2kk37xai";
    fetchSubmodules = true; # data dir for tests
  };

  postPatch = ''
    echo '#define PSAUTOHINT_VERSION "${finalAttrs.version}"' > libpsautohint/src/version.h
    sed -i '/use_scm_version/,+3d' setup.py
    sed -i '/setup(/a \     version="${finalAttrs.version}",' setup.py
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    fonttools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-xdist
  ];

  disabledTests = lib.optionals (!runAllTests) [
    # Slow tests, reduces test time from ~5 mins to ~30s
    "test_mmufo"
    "test_flex_ufo"
    "test_ufo"
    "test_flex_otf"
    "test_multi_outpath"
    "test_mmhint"
    "test_otf"
    # flaky tests (see https://github.com/adobe-type-tools/psautohint/issues/385)
    "test_hashmap_old_version"
    "test_hashmap_no_version"
  ];

  passthru.tests = {
    fullTestsuite = psautohint.override { runAllTests = true; };
  };

  meta = {
    description = "Script to normalize the XML and other data inside of a UFO";
    homepage = "https://github.com/adobe-type-tools/psautohint";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
})
