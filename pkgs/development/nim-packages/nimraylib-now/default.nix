<<<<<<< HEAD
{ lib, nimPackages, fetchFromGitHub, raylib }:
=======
{ lib, nimPackages, fetchFromGitHub }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

nimPackages.buildNimPackage rec {
  pname = "nimraylib-now";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "greenfork";
    repo = "nimraylib_now";
    rev = "v${version}";
    sha256 = "sha256-18YiAzJ46dpD5JN+gH0MWKchZ5YLPBNcm9eVFnyy2Sw=";
  };

<<<<<<< HEAD
  propagatedBuildInputs = [ raylib ];

  doCheck = false; # no $DISPLAY available

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    homepage = "https://github.com/greenfork/nimraylib_now";
    description = "The Ultimate Raylib gaming library wrapper for Nim";
    license = licenses.mit;
    maintainers = with maintainers; [ annaaurora ];
  };
}
