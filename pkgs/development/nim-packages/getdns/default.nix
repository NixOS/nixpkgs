{ lib, buildNimPackage, fetchFromSourcehut, pkg-config, getdns }:

buildNimPackage rec {
  pname = "getdns";
  version = "20221222";
  src = fetchFromSourcehut {
    owner = "~ehmry";
    repo = pname + "-nim";
    rev = version;
    hash = "sha256-y7yzY1PcodIK2kC9409FuTpLn0TsWHGiEPnrULrob+k=";
  };

  propagatedNativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ getdns ];

<<<<<<< HEAD
=======
  doCheck = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  checkPhase = "nim c tests/test_example_synchronous";
    # The test requires network but check if it builds.

  meta = {
    inherit (getdns.meta) homepage license platforms;
    description = "Nim wrapper over the getdns library";
    maintainers = with lib.maintainers; [ ehmry ];
  };
}
