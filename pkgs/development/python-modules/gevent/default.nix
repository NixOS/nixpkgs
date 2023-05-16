{ lib
, fetchPypi
, buildPythonPackage
, isPyPy
, python
, libev
<<<<<<< HEAD
, cffi
, cython_3
, greenlet
, setuptools
, wheel
=======
, greenlet
, setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

  nativeBuildInputs = [
<<<<<<< HEAD
    cython_3
    setuptools
    wheel
  ] ++ lib.optionals (!isPyPy) [
    cffi
=======
    setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

  meta = with lib; {
    description = "Coroutine-based networking library";
    homepage = "http://www.gevent.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.unix;
  };
}
