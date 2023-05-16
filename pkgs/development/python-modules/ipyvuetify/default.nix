{ lib
, buildPythonPackage
, fetchPypi
  # Python Inputs
, ipyvue
}:

buildPythonPackage rec {
  pname = "ipyvuetify";
<<<<<<< HEAD
  version = "1.8.10";
=======
  version = "1.8.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # GitHub version tries to run npm (Node JS)
  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-m6RCeUefM/XLg69AaqgTBQ7pYgGVXCy6CH/SOoQ9W04=";
=======
    hash = "sha256-viBWeFLGuKQKs9wXO3EULTNorrW25P2DFX1t5OmUcW0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ ipyvue ];

  doCheck = false;  # no tests on PyPi/GitHub
  pythonImportsCheck = [ "ipyvuetify" ];

  meta = with lib; {
    description = "Jupyter widgets based on Vuetify UI Components.";
    homepage = "https://github.com/mariobuikhuizen/ipyvuetify";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
