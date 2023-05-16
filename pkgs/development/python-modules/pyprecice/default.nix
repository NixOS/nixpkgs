{ lib
, buildPythonPackage
, cython
, fetchFromGitHub
, mpi4py
, numpy
, precice
<<<<<<< HEAD
, pkgconfig
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyprecice";
<<<<<<< HEAD
  version = "2.5.0.4";
=======
  version = "2.5.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "precice";
    repo = "python-bindings";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-Nau4ytOSv5WOly/hbHO2M6Rgx1ileJrzfCfNJFnwVaw=";
=======
    hash = "sha256-ppDilMwRxVsikTFQMNRYL0G1/HvVomz2S/2yx43u000=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cython
<<<<<<< HEAD
    pkgconfig
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    numpy
    mpi4py
    precice
  ];

  # Disable Test because everything depends on open mpi which requires network
  doCheck = false;

  # Do not use pythonImportsCheck because this will also initialize mpi which requires a network interface

  meta = with lib; {
    description = "Python language bindings for preCICE";
    homepage = "https://github.com/precice/python-bindings";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
