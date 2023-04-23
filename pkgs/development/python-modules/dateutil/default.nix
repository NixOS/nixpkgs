{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, six
}:

buildPythonPackage rec {
  pname = "python-dateutil";
  version = "2.8.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ASPKzBYnrhnd88J6XeW9Z+5FhvvdZEDZdI+Ku0g9PoY=";
  };

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
    description = "Powerful extensions to the standard datetime module";
    homepage = "https://github.com/dateutil/dateutil/";
    license = with licenses; [ asl20 bsd3 ];
    maintainers = with maintainers; [ dotlambda ];
  };
}
