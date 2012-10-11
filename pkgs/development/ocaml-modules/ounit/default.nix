{stdenv, fetchurl, ocaml, findlib}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in

stdenv.mkDerivation {
  name = "ounit-1.1.2";

  src = fetchurl {
    url = http://forge.ocamlcore.org/frs/download.php/886/ounit-1.1.2.tar.gz;
    sha256 = "e6bc1b0cdbb5b5552d85bee653e23aafe20bb97fd7cd229c867d01ff999888e3";
  };

  buildInputs = [ocaml findlib];

  dontAddPrefix = true;

  doCheck = true;

  checkTarget = "test";

  createFindlibDestdir = true;

  meta = {
    homepage = http://www.xs4all.nl/~mmzeeman/ocaml/;
    description = "Unit test framework for OCaml";
    license = stdenv.lib.licenses.mit;
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
