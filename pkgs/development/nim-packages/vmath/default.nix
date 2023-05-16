{ lib, stdenv, buildNimPackage, fetchFromGitHub }:

buildNimPackage rec {
  pname = "vmath";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "treeform";
    repo = pname;
    rev = version;
    hash = "sha256-/v0lQIOMogTxFRtbssziW4W6VhMDepM6Si8igLgcx30=";
  };

<<<<<<< HEAD
  nimFlags = [ "--mm:refc" ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  doCheck = !stdenv.isDarwin;

  meta = with lib;
    src.meta // {
      description = "Math vector library for graphical things";
      license = [ licenses.mit ];
      maintainers = [ maintainers.ehmry ];
    };
}
