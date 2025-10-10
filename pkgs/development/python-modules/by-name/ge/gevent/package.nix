{
  stdenv,
  lib,
  fetchPypi,
  buildPythonPackage,
  isPyPy,
  python,
  libev,
  cffi,
  cython,
  greenlet,
  importlib-metadata,
  setuptools,
  zope-event,
  zope-interface,
  c-ares,
  libuv,

  # for passthru.tests
  dulwich,
  gunicorn,
  pika,
}:

buildPythonPackage rec {
  pname = "gevent";
  version = "25.5.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WCyUj6miMYi4kNC8Ewc0pQbQOaLlrYfa4nakVsxoPmE=";
  };

  build-system = [
    cython
    setuptools
  ]
  ++ lib.optionals (!isPyPy) [ cffi ];

  buildInputs = [
    libev
    libuv
    c-ares
  ];

  dependencies = [
    importlib-metadata
    zope-event
    zope-interface
  ]
  ++ lib.optionals (!isPyPy) [ greenlet ];

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
  };

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
      pika
      ;
  }
  // lib.filterAttrs (k: v: lib.hasInfix "gevent" k) python.pkgs;

  GEVENTSETUP_EMBED = "0";

  meta = with lib; {
    description = "Coroutine-based networking library";
    homepage = "http://www.gevent.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.unix;
  };
}
