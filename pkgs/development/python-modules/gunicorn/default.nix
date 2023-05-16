{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, packaging
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonOlder
, eventlet
, gevent
, pytestCheckHook
<<<<<<< HEAD
=======
, setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "gunicorn";
<<<<<<< HEAD
  version = "21.2.0";
  format = "setuptools";
=======
  version = "20.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "benoitc";
    repo = "gunicorn";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-xP7NNKtz3KNrhcAc00ovLZRx2h6ZqHbwiFOpCiuwf98=";
  };

=======
    hash = "sha256-xdNHm8NQWlAlflxof4cz37EoM74xbWrNaf6jlwwzHv4=";
  };

  patches = [
    (fetchpatch {
      # fix eventlet 0.30.3+ compability
      url = "https://github.com/benoitc/gunicorn/commit/6a8ebb4844b2f28596ffe7421eb9f7d08c8dc4d8.patch";
      hash = "sha256-+iApgohzPZ/cHTGBNb7XkqLaHOVVPF26BnPUsvISoZw=";
    })
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=gunicorn --cov-report=xml" ""
  '';

  propagatedBuildInputs = [
<<<<<<< HEAD
    packaging
=======
    setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    eventlet
    gevent
    pytestCheckHook
  ];

  pythonImportsCheck = [ "gunicorn" ];

  meta = with lib; {
    homepage = "https://github.com/benoitc/gunicorn";
    description = "gunicorn 'Green Unicorn' is a WSGI HTTP Server for UNIX, fast clients and sleepy applications";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
