{ lib
, fetchPypi
, buildPythonPackage
, isPyPy
, python
, libev
, cffi
, cython_3
, greenlet
, importlib-metadata
, setuptools
, wheel
, zope-event
, zope-interface
, pythonOlder

# for passthru.tests
, dulwich
, gunicorn
, opentracing
, pika
}:

buildPythonPackage rec {
  pname = "gevent";
  version = "23.9.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-csACI1OQ1G+Uk4qWkg2IVtT/2d32KjA6DXwRiJQJfjQ=";
  };

  nativeBuildInputs = [
    cython_3
    setuptools
    wheel
  ] ++ lib.optionals (!isPyPy) [
    cffi
  ];

  buildInputs = [
    libev
  ];

  propagatedBuildInputs = [
    importlib-metadata
    zope-event
    zope-interface
  ] ++ lib.optionals (!isPyPy) [
    greenlet
  ];

  # Bunch of failures.
  doCheck = false;

  pythonImportsCheck = [
    "gevent"
    "gevent.events"
  ];

  passthru.tests = {
    inherit
      dulwich
      gunicorn
      opentracing
      pika;
  } // lib.filterAttrs (k: v: lib.hasInfix "gevent" k) python.pkgs;

  meta = with lib; {
    description = "Coroutine-based networking library";
    homepage = "http://www.gevent.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.unix;
  };
}
