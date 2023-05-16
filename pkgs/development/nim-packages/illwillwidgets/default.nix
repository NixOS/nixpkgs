<<<<<<< HEAD
{ lib, buildNimPackage, fetchFromGitHub, illwill }:
=======
{ lib, buildNimPackage, fetchFromGitHub }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildNimPackage rec {
  pname = "illwillwidgets";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "enthus1ast";
    repo = "illwillWidgets";
    rev = "04f507cfd651df430b1421403b3a70cb061c4624";
    hash = "sha256-YVNdgs8jquJ58qbcyNMMJt+hJYcvahYpkSrDBbO4ILU=";
  };

<<<<<<< HEAD
  propagatedBuildInputs = [ illwill ];
  doCheck = false;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib;
    src.meta // {
      description = "Mouse enabled widgets for illwill";

      license = [ licenses.mit ];
      maintainers = with maintainers; [ marcusramberg ];
    };
}
