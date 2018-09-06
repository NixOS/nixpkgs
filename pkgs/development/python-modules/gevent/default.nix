{ stdenv, fetchPypi, buildPythonPackage, isPyPy, python, libev, greenlet }:

buildPythonPackage rec {
  pname = "gevent";
  version = "1.3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7b413c391e8ad6607b7f7540d698a94349abd64e4935184c595f7cdcc69904c6";
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
