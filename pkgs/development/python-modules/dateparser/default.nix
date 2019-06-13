{ lib, fetchPypi, buildPythonPackage
, nose
, parameterized
, mock
, glibcLocales
, six
, jdatetime
, dateutil
, umalqurra
, pytz
, tzlocal
, regex
, ruamel_yaml }:

buildPythonPackage rec {
  pname = "dateparser";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "42d51be54e74a8e80a4d76d1fa6e4edd997098fce24ad2d94a2eab5ef247193e";
  };

  checkInputs = [ nose mock parameterized six glibcLocales ];
  preCheck =''
    # skip because of missing convertdate module, which is an extra requirement
    rm tests/test_jalali.py
  '';

  propagatedBuildInputs = [
    # install_requires
    dateutil pytz regex tzlocal
    # extra_requires
    jdatetime ruamel_yaml umalqurra
  ];

  meta = with lib; {
    description = "Date parsing library designed to parse dates from HTML pages";
    homepage = https://github.com/scrapinghub/dateparser;
    license = licenses.bsd3;
  };
}
