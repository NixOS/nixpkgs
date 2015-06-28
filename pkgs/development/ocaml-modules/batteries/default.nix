{ stdenv, fetchzip, ocaml, findlib, qtest }:

let version = "2.3.1"; in

stdenv.mkDerivation {
  name = "ocaml-batteries-${version}";

  src = fetchzip {
    url = "https://github.com/ocaml-batteries-team/batteries-included/archive/v${version}.tar.gz";
    sha256 = "1hjbzczchqnnxbn4ck84j5pi6prgfjfjg14kg26fzqz3gql427rl";
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
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
