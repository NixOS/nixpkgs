{ lib
, isPy27
, buildPythonPackage
, fetchPypi
  # Python Inputs
, ipywidgets
}:

buildPythonPackage rec {
  pname = "ipyvue";
<<<<<<< HEAD
  version = "1.10.1";
=======
  version = "1.9.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-IGFc6GulFs8Leq2EzGB+TiyRBCMulUzQ7MvzNTCl4dQ=";
=======
    hash = "sha256-hBqNvg6dKx6P5Yo17nUA9ztmvQjz+ChNFWnD2OOPp3U=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ ipywidgets ];

  doCheck = false;  # No tests in package or GitHub
  pythonImportsCheck = [ "ipyvue" ];

  meta = with lib; {
<<<<<<< HEAD
    description = "Jupyter widgets base for Vue libraries";
    homepage = "https://github.com/mariobuikhuizen/ipyvue";
=======
    description = "Jupyter widgets base for Vue libraries.";
    homepage = "https://github.com/mariobuikhuizen/ipyvuetify";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
