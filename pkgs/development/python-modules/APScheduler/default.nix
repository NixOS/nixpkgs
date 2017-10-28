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
  version = "3.4.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b51118a8ed014104f7e440456dcbd90f2015aea7bcc34c57e307fb34bc746316";
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