{ lib, fetchPypi, buildPythonPackage, isPyPy, python, libev, greenlet
, zope_interface
}:

buildPythonPackage rec {
  pname = "gevent";
  version = "21.12.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f48b64578c367b91fa793bf8eaaaf4995cb93c8bc45860e473bf868070ad094e";
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
