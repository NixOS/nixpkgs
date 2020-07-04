{ stdenv, fetchPypi, buildPythonPackage, isPyPy, python, libev, greenlet
, zope_interface
}:

buildPythonPackage rec {
  pname = "gevent";
  version = "20.5.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2756de36f56b33c46f6cc7146a74ba65afcd1471922c95b6771ce87b279d689c";
  };

  buildInputs = [ libev ];
  propagatedBuildInputs = [
    zope_interface
  ] ++ stdenv.lib.optionals (!isPyPy) [ greenlet ];

  checkPhase = ''
    cd greentest
    ${python.interpreter} testrunner.py
  '';

  # Bunch of failures.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Coroutine-based networking library";
    homepage = "http://www.gevent.org/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
