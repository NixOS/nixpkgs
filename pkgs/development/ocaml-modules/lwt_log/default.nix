{ stdenv, ocaml, findlib, dune, lwt }:

stdenv.mkDerivation rec {
  version = "1.0.0";
  name = "ocaml${ocaml.version}-lwt_log-${version}";

  inherit (lwt) src;

  buildInputs = [ ocaml findlib dune ];

  propagatedBuildInputs = [ lwt ];

  buildPhase = "dune build -p lwt_log";

  inherit (dune) installPhase;

  meta = {
    description = "Lwt logging library (deprecated)";
    homepage = "https://github.com/aantron/lwt_log";
    license = stdenv.lib.licenses.lgpl21;
    inherit (ocaml.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };
}
