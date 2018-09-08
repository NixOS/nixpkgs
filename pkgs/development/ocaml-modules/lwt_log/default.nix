{ stdenv, ocaml, findlib, jbuilder, lwt }:

stdenv.mkDerivation rec {
  version = "1.0.0";
  name = "ocaml${ocaml.version}-lwt_log-${version}";

  inherit (lwt) src;

  buildInputs = [ ocaml findlib jbuilder ];

  propagatedBuildInputs = [ lwt ];

  buildPhase = "jbuilder build -p lwt_log";

  inherit (jbuilder) installPhase;

  meta = {
    description = "Lwt logging library (deprecated)";
    homepage = https://github.com/aantron/lwt_log;
    license = stdenv.lib.licenses.lgpl21;
    inherit (ocaml.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };
}
