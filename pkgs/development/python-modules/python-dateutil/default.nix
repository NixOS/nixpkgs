{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, six
}:

buildPythonPackage rec {
  pname = "python-dateutil";
  version = "2.9.0.post0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-N91UII2n4c2HU4ghfV4A69QXkkn5D7ckN+kaNUWaCtM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools_scm<8.0" "setuptools_scm"
  '';

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ six ];

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

  meta = with lib; {
    changelog = "https://github.com/dateutil/dateutil/blob/${version}/NEWS";
    description = "Powerful extensions to the standard datetime module";
    homepage = "https://github.com/dateutil/dateutil/";
    license = with licenses; [ asl20 bsd3 ];
    maintainers = with maintainers; [ dotlambda ];
  };
}
