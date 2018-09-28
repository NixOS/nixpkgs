{ stdenv, fetchFromGitHub, ocaml, findlib, dune, lwt }:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "lwt_log is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  version = "1.1.0";
  name = "ocaml${ocaml.version}-lwt_log-${version}";

  src = fetchFromGitHub {
    owner = "aantron";
    repo = "lwt_log";
    rev = version;
    sha256 = "1c58gkqfvyf2j11jwj2nh4iq999wj9xpnmr80hz9d0nk9fv333pi";
  };

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
