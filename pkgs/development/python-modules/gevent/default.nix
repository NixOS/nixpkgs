{ lib, fetchPypi, buildPythonPackage, isPyPy, python, libev, greenlet
, zope_interface
}:

buildPythonPackage rec {
  pname = "gevent";
  version = "20.9.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13aw9x6imsy3b369kfjblqiwfni69pp32m4r13n62r9k3l2lhvaz";
  };

  buildInputs = [ libev ];
  propagatedBuildInputs = [
    zope_interface
  ] ++ lib.optionals (!isPyPy) [ greenlet ];

  checkPhase = ''
    cd greentest
    ${python.interpreter} testrunner.py
  '';

  # Bunch of failures.
  doCheck = false;

  meta = with lib; {
    description = "Coroutine-based networking library";
    homepage = "http://www.gevent.org/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
