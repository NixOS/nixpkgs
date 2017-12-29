{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, qtest }:

let version = "2.7.0"; in

stdenv.mkDerivation {
  name = "ocaml-batteries-${version}";

  src = fetchzip {
    url = "https://github.com/ocaml-batteries-team/batteries-included/archive/v${version}.tar.gz";
    sha256 = "02rgfylz6x4y2030cclf9zwk2i8xqsydn1y9hjkja2qsk895bwfb";
  };

  buildInputs = [ ocaml findlib ocamlbuild qtest ];

  configurePhase = "true"; 	# Skip configure

  doCheck = true;
  checkTarget = "test test";

  createFindlibDestdir = true;

  meta = {
    homepage = http://batteries.forge.ocamlcore.org/;
    description = "OCaml Batteries Included";
    longDescription = ''
      A community-driven effort to standardize on an consistent, documented,
      and comprehensive development platform for the OCaml programming
      language.
    '';
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
