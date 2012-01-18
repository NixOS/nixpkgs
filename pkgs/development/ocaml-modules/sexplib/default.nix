{stdenv, fetchurl, ocaml, findlib, ocaml_typeconv}:

# note: only works with ocaml>3.12
# use version 5.2.0 if you still want an 3.11 version...

stdenv.mkDerivation {
  name = "ocaml-sexplib-7.0.4";

  src = fetchurl {
    url = "http://forge.ocamlcore.org/frs/download.php/699/sexplib-7.0.4.tar.gz";
    sha256 = "83c6c771f423d91bebc4f57202066358adf3775fb000dd780079f51436045a43";
  };

  buildInputs = [ocaml findlib ocaml_typeconv];

  createFindlibDestdir = true;

  configurePhase = "true";

  meta = {
    homepage = "http://forge.ocamlcore.org/projects/sexplib/";
    description = "Library for serializing OCaml values to and from S-expressions.";
    license = "LGPL";
    platforms = ocaml.meta.platforms;
  };
}
