{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pypresence";
<<<<<<< HEAD
  version = "4.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-phkaOvM6lmfypO8BhVd8hrli7nCqgmQ8Rydopv7R+/M=";
=======
  version = "4.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "691daf98c8189fd216d988ebfc67779e0f664211512d9843f37ab0d51d4de066";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  doCheck = false; # tests require internet connection
  pythonImportsCheck = [ "pypresence" ];

  meta = with lib; {
    homepage = "https://qwertyquerty.github.io/pypresence/html/index.html";
    description = "Discord RPC client written in Python";
    license = licenses.mit;
    maintainers = with maintainers; [ xfix ];
  };
}
