{ lib, fetchFromGitHub, stdenv
, findlib, ocaml, ocamlbuild
}:

<<<<<<< HEAD
lib.throwIf (lib.versionOlder ocaml.version "4.02")
  "sosa is not available for OCaml ${ocaml.version}"
=======
if lib.versionOlder ocaml.version "4.02"
then throw "sosa is not available for OCaml ${ocaml.version}"
else
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-sosa";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "hammerlab";
    repo = "sosa";
    rev = "sosa.${version}";
    sha256 = "053hdv6ww0q4mivajj4iyp7krfvgq8zajq9d8x4mia4lid7j0dyk";
  };

<<<<<<< HEAD
  postPatch = lib.optionalString (lib.versionAtLeast ocaml.version "4.07") ''
    for p in functors list_of of_mutable
    do
      substituteInPlace src/lib/$p.ml --replace Pervasives. Stdlib.
    done
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [ ocaml ocamlbuild findlib ];

  strictDeps = true;

  buildPhase = "make build";

  createFindlibDestdir = true;

  doCheck = true;

  meta = with lib; {
    homepage = "http://www.hammerlab.org/docs/sosa/master/index.html";
    description = "Sane OCaml String API";
    license = licenses.isc;
    maintainers = [ maintainers.alexfmpe ];
  };
}
