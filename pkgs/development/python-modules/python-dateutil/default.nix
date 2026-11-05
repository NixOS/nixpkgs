{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-fancy-pypi-readme,
  hatchling,
  hatch-vcs,
  tzdata,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-dateutil";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dateutil";
    repo = "dateutil";
    tag = finalAttrs.version;
    hash = "sha256-rd49RRes+SeY1CLgGzLaj0uCfAMQ3FyWIQef6s1hzRs=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  dependencies = [ tzdata ];

  # cyclic dependency: tests need freezegun, which depends on python-dateutil
  doCheck = false;

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
