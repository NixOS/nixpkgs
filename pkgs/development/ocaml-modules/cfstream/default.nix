<<<<<<< HEAD
{ lib, buildDunePackage, fetchFromGitHub, ocaml, m4, camlp-streams, core_kernel, ounit }:
=======
{ lib, buildDunePackage, fetchFromGitHub, m4, camlp-streams, core_kernel, ounit }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildDunePackage rec {
  pname = "cfstream";
  version = "1.3.2";

<<<<<<< HEAD
=======
  duneVersion = "3";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  minimalOCamlVersion = "4.04.1";

  src = fetchFromGitHub {
    owner = "biocaml";
    repo   = pname;
    rev    = version;
    hash = "sha256-iSg0QsTcU0MT/Cletl+hW6bKyH0jkp7Jixqu8H59UmQ=";
  };

<<<<<<< HEAD
  patches = [ ./git_commit.patch ./janestreet-0.16.patch ];
=======
  patches = [ ./git_commit.patch ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  strictDeps = true;

  nativeBuildInputs = [ m4 ];
  checkInputs = [ ounit ];
  propagatedBuildInputs = [ camlp-streams core_kernel ];

<<<<<<< HEAD
  doCheck = lib.versionAtLeast ocaml.version "4.08";
=======
  doCheck = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Simple Core-inspired wrapper for standard library Stream module";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.lgpl21;
  };
}
