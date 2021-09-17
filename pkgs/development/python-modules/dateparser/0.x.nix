{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, parameterized
, pytestCheckHook
, python-dateutil
, pytz
, regex
, tzlocal
, convertdate
, umalqurra
, jdatetime
, ruamel_yaml
}:

buildPythonPackage rec {
  pname = "dateparser";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "scrapinghub";
    repo = "dateparser";
    rev = "v${version}";
    sha256 = "0j3sm4hlx7z0ci5fnjq5n9i02vvlfz0wxa889ydryfknjhy5apqw";
  };

  checkInputs = [
    mock
    parameterized
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests" ];

  disabledTestPaths = [
    "tests/test_dateparser_data_integrity.py" # ImportError: No module named ruamel.yaml
  ];

  propagatedBuildInputs = [
    # install_requires
    python-dateutil pytz regex tzlocal
    # extra_requires
    convertdate umalqurra jdatetime ruamel_yaml
  ];

  pythonImportsCheck = [ "dateparser" ];

  meta = with lib; {
    description = "Date parsing library designed to parse dates from HTML pages";
    homepage = "https://github.com/scrapinghub/dateparser";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
