{ stdenv, fetchurl, buildPythonPackage, isPyPy, python, libev, greenlet }:

buildPythonPackage rec {
  name = "gevent-1.1.2";

  src = fetchurl {
    url = "mirror://pypi/g/gevent/${name}.tar.gz";
    sha256 = "cb15cf73d69a2eeefed330858f09634e2c50bf46da9f9e7635730fcfb872c02c";
  };

  # Why do we have this patch?
  postPatch = ''
    substituteInPlace libev/ev.c --replace \
      "ecb_inline void ecb_unreachable (void) ecb_noreturn" \
      "ecb_inline ecb_noreturn void ecb_unreachable (void)"
  '';

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
