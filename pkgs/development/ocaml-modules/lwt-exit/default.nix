{ lib
, fetchFromGitLab
, buildDunePackage
, lwt
, ptime
}:

buildDunePackage rec {
  pname = "lwt-exit";
  version = "1.0";
  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = pname;
<<<<<<< HEAD
    rev = version;
=======
    rev = "${version}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    sha256 = "1k763bmj1asj9ijar39rh3h1d59rckmsf21h2y8966lgglsf42bd";
  };

  useDune2 = true;

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    lwt
    ptime
  ];

  # for some reason this never exits
  doCheck = false;

  meta = {
    description = "An opinionated clean-exit and signal-handling library for Lwt programs";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
