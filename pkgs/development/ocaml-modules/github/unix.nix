{ lib, buildDunePackage, github
, cohttp, cohttp-lwt-unix, stringext, cmdliner, lwt
}:

buildDunePackage {
  pname = "github-unix";
  inherit (github) version src;

<<<<<<< HEAD
  postPatch = ''
    substituteInPlace unix/dune --replace 'github bytes' 'github'
  '';
=======
  duneVersion = "3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = [
    github
    cohttp
    cohttp-lwt-unix
    stringext
    cmdliner
    lwt
  ];

  meta = github.meta // {
    description = "GitHub APIv3 Unix library";
  };
}
