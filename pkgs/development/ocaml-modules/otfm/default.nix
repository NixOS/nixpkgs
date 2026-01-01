{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  findlib,
  ocamlbuild,
  topkg,
  uutf,
}:

let
  pname = "otfm";
  version = "0.4.0";
  webpage = "https://erratique.ch/software/${pname}";
in

stdenv.mkDerivation {

  pname = "ocaml${ocaml.version}-${pname}";
  inherit version;

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    hash = "sha256-02U23mYTy0ZJgSObDoyygPTGEMC4/Zge5bux4wshaEE=";
  };

  nativeBuildInputs = [
    ocaml
    findlib
    ocamlbuild
    topkg
  ];
  buildInputs = [ topkg ];

  propagatedBuildInputs = [ uutf ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "OpenType font decoder for OCaml";
    longDescription = ''
      Otfm is an in-memory decoder for the OpenType font data format. It
      provides low-level access to font tables and functions to decode some
      of them.
    '';
    homepage = webpage;
<<<<<<< HEAD
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.jirkamarsik ];
=======
    license = licenses.bsd3;
    maintainers = [ maintainers.jirkamarsik ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "otftrip";
    inherit (ocaml.meta) platforms;
  };
}
