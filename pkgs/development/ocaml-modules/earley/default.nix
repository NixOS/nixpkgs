{ stdenv, fetchFromGitHub, which, ocaml, findlib, ocamlbuild }:

if !stdenv.lib.versionAtLeast ocaml.version "4.03"
then throw "earley is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  version = "1.0.2";
  name = "ocaml${ocaml.version}-earley-${version}";
  src = fetchFromGitHub {
    owner = "rlepigre";
    repo = "ocaml-earley";
    rev = "ocaml-earley_${version}";
    sha256 = "110njakmx1hyq42hyr6gx6qhaxly860whfhd6r0vks4yfp68qvcx";
  };

  buildInputs = [ which ocaml findlib ocamlbuild ];

  createFindlibDestdir = true;

  meta = {
    description = "Parser combinators based on Earley Algorithm";
    license = stdenv.lib.licenses.cecill-b;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
    inherit (src.meta) homepage;
  };
}
