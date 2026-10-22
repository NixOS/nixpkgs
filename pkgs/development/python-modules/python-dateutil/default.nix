{
  lib,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,
  hypothesis,
  pytest-cov,
  pytestCheckHook,
  tzdata,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-dateutil";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dateutil";
    repo = "dateutil";
    tag = "${finalAttrs.version}";
    hash = "sha256-rd49RRes+SeY1CLgGzLaj0uCfAMQ3FyWIQef6s1hzRs=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  dependencies = [
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
