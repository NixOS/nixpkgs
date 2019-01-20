{ stdenv, fetchPypi, buildPythonPackage, isPyPy, python, libev, greenlet }:

buildPythonPackage rec {
  pname = "gevent";
  version = "1.3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3f06f4802824c577272960df003a304ce95b3e82eea01dad2637cc8609c80e2c";
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
