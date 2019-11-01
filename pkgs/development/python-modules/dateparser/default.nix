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
  version = "0.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e1eac8ef28de69a554d5fcdb60b172d526d61924b1a40afbbb08df459a36006b";
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
