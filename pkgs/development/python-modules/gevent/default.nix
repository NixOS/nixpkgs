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
    # Replace deprecated pkg_resources with importlib-metadata
    (fetchpatch {
      url = "https://github.com/gevent/gevent/commit/bd96d8e14dc99f757de22ab4bb98439f912dab1e.patch";
      hash = "sha256-Y+cxIScuEgAVYmmxBJ8OI+JuJ4G+iiROTcRdWglo3l0=";
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

  meta = with lib; {
    description = "Coroutine-based networking library";
    homepage = "http://www.gevent.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.unix;
  };
}
