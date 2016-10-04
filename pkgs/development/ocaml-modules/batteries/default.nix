{ stdenv, fetchzip, ocaml, findlib, qtest }:

let version = "2.5.2"; in

stdenv.mkDerivation {
  name = "ocaml-batteries-${version}";

  src = fetchzip {
    url = "https://github.com/ocaml-batteries-team/batteries-included/archive/v${version}.tar.gz";
    sha256 = "01v7sp8vsqlfrmpji5pkrsjl43r3q8hk1a4z4lmyy9y2i0fqwl07";
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
