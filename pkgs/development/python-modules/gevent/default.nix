{ lib
, fetchPypi
, buildPythonPackage
, isPyPy
, python
, libev
, greenlet
, setuptools
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
  ];

  nativeBuildInputs = [
    setuptools
  ];

  buildInputs = [
    libev
  ];

  propagatedBuildInputs = [
    zope_event
    zope_interface
  ] ++ lib.optionals (!isPyPy) [
    greenlet
  ];

  # Bunch of failures.
  doCheck = false;

  pythonImportsCheck = [
    "gevent"
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
