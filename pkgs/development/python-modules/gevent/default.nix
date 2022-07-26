{ lib
, fetchPypi
, buildPythonPackage
, isPyPy
, python
, libev
, greenlet
, zope_event
, zope_interface
, pythonOlder
}:

buildPythonPackage rec {
  pname = "gevent";
  version = "21.12.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9ItkV4w2e5H6eTv46qr0mVy5PIvEWGDkc7+GgHCtCU4=";
  };

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

  meta = with lib; {
    description = "Coroutine-based networking library";
    homepage = "http://www.gevent.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.unix;
  };
}
