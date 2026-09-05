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

buildPythonPackage (finalAttrs: {
  pname = "gevent";
  version = "26.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-FlXrBMHiDXGyqko8dSgWLdWP9sxGoDevHwH1NMgP77o=";
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

  env = {
    GEVENTSETUP_EMBED = "0";
  }
  // lib.optionalAttrs stdenv.cc.isGNU {
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

  __structuredAttrs = true;

  meta = {
    description = "Coroutine-based networking library";
    homepage = "http://www.gevent.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bjornfor ];
    platforms = lib.platforms.unix;
  };
})
