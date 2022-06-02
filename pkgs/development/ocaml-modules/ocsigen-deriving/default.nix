{ stdenv
, lib
, fetchFromGitHub
, ocaml
, findlib
, ocamlbuild
, oasis
, camlp4
, num
}:

if lib.versionOlder ocaml.version "4.03"
then throw "ocsigen-deriving is not available of OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-ocsigen-deriving";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "deriving";
    rev = version;
    sha256 = "sha256:09rp9mrr551na0nmclpxddlrkb6l2d7763xv14xfx467kff3z0wf";
  };

  createFindlibDestdir = true;

  nativeBuildInputs = [ ocaml findlib ocamlbuild oasis camlp4 ];
  buildInputs = [ oasis camlp4 ocamlbuild num ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/ocsigen/deriving";
    description = "Extension to OCaml for deriving functions from type declarations";
    license = lib.licenses.mit;
    inherit (ocaml.meta) platforms;
    maintainers = with lib.maintainers; [
      gal_bolle
      vbgl
    ];
  };


}
