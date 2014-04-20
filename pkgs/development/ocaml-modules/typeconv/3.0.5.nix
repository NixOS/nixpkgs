{stdenv, fetchurl, ocaml, findlib}:

# note: works only with ocaml >3.12

stdenv.mkDerivation {
  name = "ocaml-typeconv-3.0.5";

  src = fetchurl {
    url = "http://forge.ocamlcore.org/frs/download.php/821/type_conv-3.0.5.tar.gz";
    sha256 = "90ac6c401a600a23012a3f513def6f67d4979b11bd551f4d0af78f0f0b479198";
  };

  buildInputs = [ocaml findlib ]; 

  createFindlibDestdir = true;

  meta = {
    homepage = "http://forge.ocamlcore.org/projects/type-conv/";
    description = "Support library for OCaml preprocessor type conversions";
    license = "LGPL";
    platforms = ocaml.meta.platforms;
  };
}
