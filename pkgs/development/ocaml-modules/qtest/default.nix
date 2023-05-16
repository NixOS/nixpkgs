{ lib, buildDunePackage, fetchFromGitHub, qcheck }:

buildDunePackage rec {
  pname = "qtest";
  version = "2.11.2";

<<<<<<< HEAD
=======
  duneVersion = "3";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "vincent-hugot";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VLY8+Nu6md0szW4RVxTFwlSQ9kyrgUqf7wQEA6GW8BE=";
  };

<<<<<<< HEAD
  preBuild = ''
    substituteInPlace src/dune \
      --replace "(libraries bytes)" "" \
      --replace "libraries qcheck ounit2 bytes" "libraries qcheck ounit2"
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [ qcheck ];

  meta = {
    description = "Inline (Unit) Tests for OCaml";
    inherit (src.meta) homepage;
    maintainers = with lib.maintainers; [ vbgl ];
    license = lib.licenses.gpl3;
  };
}
