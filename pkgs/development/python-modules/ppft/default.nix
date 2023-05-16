{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, python
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "ppft";
<<<<<<< HEAD
  version = "1.7.6.7";
=======
  version = "1.7.6.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-qzRDaBTi8YI481aI/YabJkGy0tjcoiuNJG9nAd/JVMg=";
=======
    hash = "sha256-+TPwQE8+gIvIYHRayzt5zU/jHqGaIIiaZF+QBBW+YPE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    six
  ];

  # darwin seems to hang
  doCheck = !stdenv.isDarwin;
  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m ppft.tests
    runHook postCheck
  '';

  pythonImportsCheck = [
    "ppft"
  ];

  meta = with lib; {
    description = "Distributed and parallel Python";
    homepage = "https://ppft.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
