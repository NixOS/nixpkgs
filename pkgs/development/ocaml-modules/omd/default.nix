{ lib, buildDunePackage, fetchurl }:

buildDunePackage rec {
  pname = "omd";
  version = "1.3.2";

  minimalOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/ocaml/omd/releases/download/${version}/omd-${version}.tbz";
    sha256 = "sha256-YCPhZCYx8I9njrVyWCCHnte7Wj/+53fN7evCjB+F+ts=";
  };

<<<<<<< HEAD
  preBuild = ''
    substituteInPlace src/dune --replace "bytes)" ")"
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = {
    description = "Extensible Markdown library and tool in OCaml";
    homepage = "https://github.com/ocaml/omd";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "omd";
  };
}
