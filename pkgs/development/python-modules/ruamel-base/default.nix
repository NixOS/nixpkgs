{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "ruamel-base";
  version = "1.0.0";

  src = fetchPypi {
    pname = "ruamel.base";
    inherit version;
    sha256 = "1wswxrn4givsm917mfl39rafgadimf1sldpbjdjws00g1wx36hf0";
  };

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "ruamel.base" ];

<<<<<<< HEAD
  pythonNamespaces = [ "ruamel" ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Common routines for ruamel packages";
    homepage = "https://sourceforge.net/projects/ruamel-base/";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
