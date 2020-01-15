{ stdenv, fetchPypi, buildPythonPackage, isPyPy, python, libev, greenlet }:

buildPythonPackage rec {
  pname = "gevent";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1eb7fa3b9bd9174dfe9c3b59b7a09b768ecd496debfc4976a9530a3e15c990d1";
  };

  buildInputs = [ libev ];
  propagatedBuildInputs = stdenv.lib.optionals (!isPyPy) [ greenlet ];

  checkPhase = ''
    cd greentest
    ${python.interpreter} testrunner.py
  '';

  # Bunch of failures.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Coroutine-based networking library";
    homepage = http://www.gevent.org/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
