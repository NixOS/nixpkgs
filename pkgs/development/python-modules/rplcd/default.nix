{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "rplcd";
<<<<<<< HEAD
  version = "1.3.1";
=======
  version = "1.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    inherit version;
    pname = "RPLCD";
<<<<<<< HEAD
    hash = "sha256-uZ0pPzWK8cBSX8/qvcZGYEnlVdtWn/vKPyF1kfwU5Pk=";
=======
    hash = "sha256-AIEiL+IPU76DF+P08c5qokiJcZdNNDJ/Jjng2Z292LY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Disable check because it depends on a GPIO library
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/dbrgn/RPLCD";
    description = ''
      Raspberry Pi LCD library for the widely used Hitachi HD44780 controller
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
