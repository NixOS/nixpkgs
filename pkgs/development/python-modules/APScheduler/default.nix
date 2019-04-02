{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pytest
, pytestcov
, sqlalchemy
, tornado
, twisted
, mock
, trollius
, gevent
, six
, pytz
, tzlocal
, funcsigs
, futures
, isPy3k
}:

buildPythonPackage rec {
  pname = "APScheduler";
  version = "3.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q22lgp001hkk4z4xs2b2hlix84ka15i576p33fmgp69zn4bhmlg";
  };

  buildInputs = [
    setuptools_scm
  ];

  checkInputs = [
    pytest
    pytestcov
    sqlalchemy
    tornado
    twisted
    mock
    trollius
    gevent
  ];

  propagatedBuildInputs = [
    six
    pytz
    tzlocal
    funcsigs
  ] ++ lib.optional (!isPy3k) futures;

  checkPhase = ''
    py.test
  '';

  # Somehow it cannot find pytestcov
  doCheck = false;

  meta = with lib; {
    description = "A Python library that lets you schedule your Python code to be executed";
    homepage = https://pypi.python.org/pypi/APScheduler/;
    license = licenses.mit;
  };
}