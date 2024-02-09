{ lib
, fetchPypi
, fetchpatch
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
, zope_event
, zope_interface
, pythonOlder

# for passthru.tests
, dulwich
, gunicorn
, opentracing
, pika
}:

buildPythonPackage rec {
  pname = "gevent";
  version = "22.10.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HKAdoXbuN7NSeicC99QNvJ/7jPx75aA7+k+e7EXlXEY=";
  };

  patches = [
    ./22.10.2-CVE-2023-41419.patch
    # Replace deprecated pkg_resources with importlib-metadata
    (fetchpatch {
      url = "https://github.com/gevent/gevent/commit/bd96d8e14dc99f757de22ab4bb98439f912dab1e.patch";
      hash = "sha256-Y+cxIScuEgAVYmmxBJ8OI+JuJ4G+iiROTcRdWglo3l0=";
      includes = [ "src/gevent/events.py" ];
    })
  ] ++ lib.optionals (pythonOlder "3.10") [
    (fetchpatch {
      url = "https://github.com/gevent/gevent/commit/07035b7e0ccf35abea20d774827423e959429df1.patch";
      hash = "sha256-w4Lw9kFALkg4QDUXLvWVmlyiOYGKE0W7kJIMd1jpGHI=";
      includes = [ "src/gevent/events.py" ];
    })
    (fetchpatch {
      url = "https://github.com/gevent/gevent/commit/d9e2479b83da1a8b2e75720d9bfa771bb97d7c94.patch";
      hash = "sha256-j6AtVCYpwPXBz8HUJHSD0VfvkBsKuZBrmHh9WRgoEl4=";
      includes = [ "src/gevent/events.py" ];
    })
  ];

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
    zope_event
    zope_interface
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
