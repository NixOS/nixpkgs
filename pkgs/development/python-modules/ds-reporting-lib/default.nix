{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ds-reporting-lib";
  version = "6.0.0b3";
  pyproject = true;

  # pypi because library is embedded into another project's repo
  src = fetchPypi {
    inherit version;
    pname = "ds_reporting_lib";
    hash = "sha256-0C/UgAM7VIWEjuRq1ZCTL5CjJ6OK+0/Yw+AN4j7jj6E=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "reporting_lib" ];

  # no tests
  doCheck = false;

  meta = {
    description = "Reporting library for owasp depscan";
    homepage = "https://pypi.org/project/ds-reporting-lib/";
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    teams = [ lib.teams.ngi ];
    license = with lib.licenses; [ mit ];
  };
}
