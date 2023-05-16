<<<<<<< HEAD
{ lib, buildDunePackage, fetchFromGitHub }:

buildDunePackage rec {
  pname = "dolog";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "UnixJunkie";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-g68260mcb4G4wX8y4T0MTaXsYnM9wn2d0V1VCdSFZjY=";
  };

  meta = {
    homepage = "https://github.com/UnixJunkie/dolog";
    description = "Minimalistic lazy logger in OCaml";
=======
{ stdenv, lib, fetchFromGitHub, ocaml, findlib, ocamlbuild }:

stdenv.mkDerivation rec {
  pname = "ocaml-dolog";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "UnixJunkie";
    repo = "dolog";
    rev = "v${version}";
    sha256 = "sha256-6wfqT5sqo4YA8XoHH3QhG6/TyzzXCzqjmnPuBArRoj8=";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild ];

  strictDeps = true;

  createFindlibDestdir = true;

  doCheck = true;
  checkTarget = "test";

  meta = {
    homepage = "https://github.com/UnixJunkie/dolog";
    description = "Minimalistic lazy logger in OCaml";
    platforms = ocaml.meta.platforms or [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
