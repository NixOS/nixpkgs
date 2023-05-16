{ lib, buildPythonPackage, fetchPypi, isPy3k
, numpy
}:

buildPythonPackage rec {
  pname = "arrayqueues";
<<<<<<< HEAD
  version = "1.4.1";
=======
  version = "1.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    sha256 = "sha256-7I+5BQO/gsvTREDkBfxrMblw3JPfY48S4KI4PCGPtFY=";
=======
    sha256 = "a955df768e39d459de28c7ea10ee02f67b1c70996cfa229846ab98df77a6fb69";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    numpy
  ];

  meta = {
    homepage = "https://github.com/portugueslab/arrayqueues";
    description = "Multiprocessing queues for numpy arrays using shared memory";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tbenst ];
  };
}
