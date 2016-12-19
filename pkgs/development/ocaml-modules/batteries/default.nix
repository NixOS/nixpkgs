{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, qtest }:

let version = "2.5.3"; in

stdenv.mkDerivation {
  name = "ocaml-batteries-${version}";

  src = fetchzip {
    url = "https://github.com/ocaml-batteries-team/batteries-included/archive/v${version}.tar.gz";
    sha256 = "047v05qy0526ad52hzhfa0giczhyzbmw9fwsn6l319icq77ms6jh";
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
