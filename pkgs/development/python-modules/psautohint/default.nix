{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  fonttools,
  lxml,
  fs, # for fonttools extras
  setuptools-scm,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-xdist,
  runAllTests ? false,
  psautohint, # for passthru.tests
}:

buildPythonPackage rec {
  pname = "psautohint";
  version = "2.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "adobe-type-tools";
    repo = "psautohint";
    rev = "v${version}";
    sha256 = "125nx7accvbk626qlfar90va1995kp9qfrz6a978q4kv2kk37xai";
    fetchSubmodules = true; # data dir for tests
  };

  postPatch = ''
    echo '#define PSAUTOHINT_VERSION "${version}"' > libpsautohint/src/version.h
    sed -i '/use_scm_version/,+3d' setup.py
    sed -i '/setup(/a \     version="${version}",' setup.py
  '';

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    fonttools
    lxml
    fs
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

  meta = with lib; {
    description = "Script to normalize the XML and other data inside of a UFO";
    homepage = "https://github.com/adobe-type-tools/psautohint";
    license = licenses.bsd3;
    maintainers = [ maintainers.sternenseemann ];
  };
}
