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
  version = "3.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c56066rx09xk1zbd156whsynlakxazqq64i509id17015wzp6jj";
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