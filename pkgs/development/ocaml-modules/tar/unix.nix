{ lib
, buildDunePackage
, tar
, cstruct-lwt
, lwt
<<<<<<< HEAD
, git
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildDunePackage rec {
  pname = "tar-unix";
  inherit (tar) version src doCheck;
<<<<<<< HEAD
=======
  duneVersion = "3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = [
    tar
    cstruct-lwt
    lwt
  ];

<<<<<<< HEAD
  nativeCheckInputs = [
    git
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = tar.meta // {
    description = "Decode and encode tar format files from Unix";
  };
}
