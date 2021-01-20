{ lib, fetchPypi, buildPythonPackage
, nose
, parameterized
, mock
, flake8
, glibcLocales
, six
, jdatetime
, dateutil
, umalqurra
, pytz
, tzlocal
, regex
, ruamel_yaml
, python
, isPy3k
}:

buildPythonPackage rec {
  pname = "dateparser";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "159cc4e01a593706a15cd4e269a0b3345edf3aef8bf9278a57dac8adf5bf1e4a";
  };

  checkInputs = [
    flake8
    nose
    mock
    parameterized
    six
    glibcLocales
  ];
  preCheck =''
    # skip because of missing convertdate module, which is an extra requirement
    rm tests/test_jalali.py
  '';

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s tests
  '';

  # Strange
  # AttributeError: 'module' object has no attribute 'config'
  doCheck = false;

  propagatedBuildInputs = [
    # install_requires
    dateutil pytz regex tzlocal
    # extra_requires
    jdatetime ruamel_yaml umalqurra
  ];

  meta = with lib; {
    description = "Date parsing library designed to parse dates from HTML pages";
    homepage = "https://github.com/scrapinghub/dateparser";
    license = licenses.bsd3;
  };
}
