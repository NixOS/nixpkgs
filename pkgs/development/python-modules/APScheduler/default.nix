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
  version = "3.3.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f68874dff1bdffcc6ce3adb7840c1e4d162c609a3e3f831351df30b75732767b";
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
    homepage = http://pypi.python.org/pypi/APScheduler/;
    license = licenses.mit;
  };
}