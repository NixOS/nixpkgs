# NOTE: Whenever you updated this version check if the `cacert` package also
#       needs an update. You can run the regular updater script for cacerts.
#       It will rebuild itself using the version of this package (NSS) and if
#       an update is required do the required changes to the expression.
#       Example: nix-shell ./maintainers/scripts/update.nix --argstr package cacert

import ./generic.nix {
<<<<<<< HEAD
  version = "3.93";
  hash = "sha256-FfVLtyBI6xBfjA6TagS4medMPbmhm7weAKzuKvlHaoo=";
=======
  version = "3.89.1";
  hash = "sha256-OtrtuecMPF9AYDv2CgHjNhkKbb4Bkp05XxawH+hKAVY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
