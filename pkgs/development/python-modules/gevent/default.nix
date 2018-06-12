{ stdenv, fetchPypi, buildPythonPackage, isPyPy, python, libev, greenlet }:

buildPythonPackage rec {
  pname = "gevent";
  version = "1.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "59465c7bce7671834f58b44ef62cd8626f1557a0e7e3de44a3b596056f8adc73";
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
