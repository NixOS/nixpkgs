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
  wheel,
  zope-event,
  zope-interface,
  pythonOlder,
  c-ares,
  libuv,

  # for passthru.tests
  dulwich,
  gunicorn,
  pika,
}:

buildPythonPackage rec {
  pname = "gevent";
  version = "24.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Qy/Hb2gKz3zxiMLuD106tztjwfAxFMfNijTOu+WqIFY=";
  };

  nativeBuildInputs = [
    cython
    setuptools
    wheel
  ] ++ lib.optionals (!isPyPy) [ cffi ];

  buildInputs = [
    libev
    libuv
    c-ares
  ];

  propagatedBuildInputs = [
    importlib-metadata
    zope-event
    zope-interface
  ] ++ lib.optionals (!isPyPy) [ greenlet ];

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
  } // lib.filterAttrs (k: v: lib.hasInfix "gevent" k) python.pkgs;

  GEVENTSETUP_EMBED = "0";

  meta = with lib; {
    description = "Coroutine-based networking library";
    homepage = "http://www.gevent.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.unix;
  };
}
