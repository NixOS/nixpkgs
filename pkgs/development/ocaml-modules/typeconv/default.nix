{stdenv, fetchurl, ocaml, findlib}:

# note: works only with ocaml >3.12

stdenv.mkDerivation {
  name = "ocaml-typeconv-3.0.4";

  src = fetchurl {
    url = "http://forge.ocamlcore.org/frs/download.php/697/ocaml-type-conv-3.0.4.tar.gz";
    sha256 = "63b6f2872d29fb4c0b1448343bb5ec0649365126756128049d45a81238b59f12";
  };

  buildInputs = [ocaml findlib ]; 

  createFindlibDestdir = true;

  configurePhase = "true";

  meta = {
    homepage = "http://forge.ocamlcore.org/projects/type-conv/";
    description = "Support library for OCaml preprocessor type conversions";
    license = "LGPL";
    platforms = ocaml.meta.platforms;
  };
}
