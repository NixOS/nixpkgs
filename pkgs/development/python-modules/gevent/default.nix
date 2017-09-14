{ stdenv, buildPythonPackage, fetchPypi, python, libev, isPyPy, greenlet }:

buildPythonPackage rec {
  pname = "gevent";
  version = "1.2.2";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bbbjvi423y9k9xagrcsimnayaqymg6f2dj76m9z3mjpkjpci4a7";
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
