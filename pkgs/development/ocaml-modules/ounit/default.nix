{stdenv, fetchurl, ocaml, findlib}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in

stdenv.mkDerivation {
  name = "ounit-1.1.0";

  src = fetchurl {
    url = http://forge.ocamlcore.org/frs/download.php/495/ounit-1.1.0.tar.gz;
    sha256 = "12vybg9xlw5c8ip23p8cljfzhkdsm25482sf1yh46fcqq8p2jmqx";
  };

  buildInputs = [ocaml findlib];

  dontAddPrefix = true;

  doCheck = true;

  checkTarget = "test";

  createFindlibDestdir = true;

  meta = {
    homepage = http://www.xs4all.nl/~mmzeeman/ocaml/;
    description = "Unit test framework for OCaml";
    license = "MIT/X11";
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
