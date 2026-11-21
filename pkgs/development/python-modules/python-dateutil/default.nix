{
  lib,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  hypothesis,
  pytest-cov,
  pytestCheckHook,
  setuptools-scm,
  six,
  tzdata,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-dateutil";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dateutil";
    repo = "dateutil";
    tag = "${finalAttrs.version}";
    hash = "sha256-mGJAC2A2pSJABV3l3lOX1aTCX3UdBrGp8vnR8qhgkSU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools_scm<8.0" "setuptools_scm"
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    six
    tzdata
  ];

  # cyclic dependency: tests need freezegun, which depends on python-dateutil
  doCheck = false;

  nativeCheckInputs = [
    attrs
    freezegun
    hypothesis
    pytest-cov
    pytestCheckHook
  ];

  disabledTests = [
    # the sandbox breaks timezone assumptions
    "test_gettz_local_abbreviation_without_time_zone_data"
    "test_tzlocal_local_time_trim_colon"
  ];

  passthru.tests = {
    pytest = finalAttrs.finalPackage.overrideAttrs {
      doInstallCheck = true;
    };
  };

  pythonImportsCheck = [
    "dateutil.easter"
    "dateutil.parser"
    "dateutil.relativedelta"
    "dateutil.rrule"
    "dateutil.tz"
    "dateutil.utils"
    "dateutil.zoneinfo"
  ];

  meta = {
    changelog = "https://github.com/dateutil/dateutil/blob/${finalAttrs.src.tag}/NEWS";
    description = "Powerful extensions to the standard datetime module";
    homepage = "https://github.com/dateutil/dateutil/";
    license = with lib.licenses; [
      asl20
      bsd3
    ];
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
