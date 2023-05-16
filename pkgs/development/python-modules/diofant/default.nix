{ lib
, buildPythonPackage
<<<<<<< HEAD
, cython
, fetchpatch
, fetchPypi
, gmpy2
=======
, fetchPypi
, gmpy2
, isort
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, mpmath
, numpy
, pythonOlder
, scipy
, setuptools-scm
<<<<<<< HEAD
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "diofant";
<<<<<<< HEAD
  version = "0.14.0";
  format = "pyproject";
  disabled = pythonOlder "3.10";
=======
  version = "0.13.0";
  disabled = pythonOlder "3.9";
  format = "pyproject";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    inherit version;
    pname = "Diofant";
<<<<<<< HEAD
    hash = "sha256-c886y37xR+4TxZw9+3tb7nkTGxWcS+Ag/ruUUdpf7S4=";
  };

  patches = [
    (fetchpatch {
      name = "remove-pip-from-build-dependencies.patch";
      url = "https://github.com/diofant/diofant/commit/117e441808faa7c785ccb81bf211772d60ebdec3.patch";
      hash = "sha256-MYk1Ku4F3hAv7+jJQLWhXd8qyKRX+QYuBzPfYWT0VbU=";
    })
  ];

  nativeBuildInputs = [
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    mpmath
  ];

  passthru.optional-dependencies = {
    exports = [
      cython
      numpy
      scipy
    ];
    gmpy = [
      gmpy2
    ];
  };

=======
    sha256 = "bac9e086a7156b20f18e3291d6db34e305338039a3c782c585302d377b74dd3c";
  };

  nativeBuildInputs = [
    isort
    setuptools-scm
  ];

  propagatedBuildInputs = [
    gmpy2
    mpmath
    numpy
    scipy
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # tests take ~1h
  doCheck = false;

  pythonImportsCheck = [ "diofant" ];

  meta = with lib; {
    description = "A Python CAS library";
    homepage = "https://diofant.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ suhr ];
  };
}
