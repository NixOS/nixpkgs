{ stdenv, fetchzip, ocaml, findlib, qtest }:

let version = "2.4.0"; in

stdenv.mkDerivation {
  name = "ocaml-batteries-${version}";

  src = fetchzip {
    url = "https://github.com/ocaml-batteries-team/batteries-included/archive/v${version}.tar.gz";
    sha256 = "0bxp5d05w1igwh9vcgvhd8sd6swf2ddsjphw0mkakdck9afnimmd";
  };

  buildInputs = [ ocaml findlib qtest ];

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
