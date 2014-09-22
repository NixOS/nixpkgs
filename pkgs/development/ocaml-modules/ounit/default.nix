{stdenv, fetchurl, ocaml, findlib, camlp4}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in

stdenv.mkDerivation {
  name = "ounit-2.0.0";

  src = fetchurl {
    url = http://forge.ocamlcore.org/frs/download.php/886/ounit-2.0.0.tar.gz;
    sha256 = "1qw8k2czy0bxhsf25kfpgywhpqmg7bi57rmyhlnmbddmvc61pg76";
  };

  buildInputs = [ocaml findlib camlp4];

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
