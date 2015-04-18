{ stdenv, fetchzip, ocaml, findlib }:

let version = "1.3.0"; in

stdenv.mkDerivation {
  name = "ocaml-stringext-${version}";

  src = fetchzip {
    url = "https://github.com/rgrinberg/stringext/archive/v${version}.tar.gz";
    sha256 = "0sd1chyxclmip0nxqhasp1ri91bwxr8nszkkr5kpja45f6bav6k9";
  };

  buildInputs = [ ocaml findlib ];

  configurePhase = "ocaml setup.ml -configure --prefix $out";
  buildPhase = "ocaml setup.ml -build";
  installPhase = "ocaml setup.ml -install";

  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/rgrinberg/stringext;
    platforms = ocaml.meta.platforms;
    description = "Extra string functions for OCaml";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
