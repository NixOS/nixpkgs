{stdenv, fetchurl, ocaml, findlib}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "1.0.3";
in

stdenv.mkDerivation {
  name = "ounit-${version}";

  src = fetchurl {
    url = "http://www.xs4all.nl/~mmzeeman/ocaml/ounit-${version}.tar.gz";
    sha256 = "1n7ylrbi2m00gn0kjg5zxnyzxki8v1dy31fcz3vh1xnwcx6hii97";
  };

  buildInputs = [ocaml findlib];

  configurePhase = "true";  	# Skip configure

  buildFlags = "all allopt";

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
