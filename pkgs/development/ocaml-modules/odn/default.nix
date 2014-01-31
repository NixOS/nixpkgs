{stdenv, fetchurl, ocaml, findlib, ocaml_typeconv, ounit}:

stdenv.mkDerivation {
  name = "ocaml-data-notation-0.0.11";

  src = fetchurl {
    url = https://forge.ocamlcore.org/frs/download.php/1310/ocaml-data-notation-0.0.11.tar.gz;
    sha256 = "09a8zdyifpc2nl4hdvg9206142y31cq95ajgij011s1qcg3z93lj";
  };

  buildInputs = [ocaml findlib ocaml_typeconv ounit];

  createFindlibDestdir = true;

  configurePhase = "ocaml setup.ml -configure";
  buildPhase     = "ocaml setup.ml -build";
  installPhase   = "ocaml setup.ml -install";

  meta = {
    description = "Store data using OCaml notation";
    homepage = https://forge.ocamlcore.org/projects/odn/;
    license = stdenv.lib.licenses.lgpl21;
    platforms = ocaml.meta.platforms;
    maintainers = with stdenv.lib.maintainers; [
      z77z
    ];
  };
}
