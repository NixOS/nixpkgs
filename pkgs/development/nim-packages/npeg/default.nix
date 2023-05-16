{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage rec {
  pname = "npeg";
  version = "1.2.1";
  src = fetchFromGitHub {
    owner = "zevv";
    repo = pname;
    rev = version;
    hash = "sha256-kN91cp50ZL4INeRWqwrRK6CAkVXUq4rN4YlcN6WL/3Y=";
  };
<<<<<<< HEAD
  nimFlags = [ "--threads:off" ];
=======
  doCheck = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = src.meta // {
    description = "NPeg is a pure Nim pattern matching library";
    maintainers = with lib.maintainers; [ ehmry ];
    license = lib.licenses.mit;
  };
}
