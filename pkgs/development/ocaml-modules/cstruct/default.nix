{ stdenv, writeText, fetchFromGitHub, ocaml, ocplib-endian, sexplib_p4, findlib, ppx_tools
, async_p4 ? null, lwt ? null, camlp4
}:

assert stdenv.lib.versionAtLeast ocaml.version "4.01";

let param =
  if stdenv.lib.versionAtLeast ocaml.version "4.02"
  then { version = "2.3.0"; sha256 = "19spsgkry41dhsbm6ij71kws90bqp7wiggc6lsqdl43xxvbgdmys"; }
  else { version = "1.9.0"; sha256 = "1c1j21zgmxi9spq23imy7byn50qr7hlds1cfpzxlsx9dp309jngy"; };
in

let opt = b: "--${if b != null then "en" else "dis"}able"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-cstruct-${param.version}";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = "ocaml-cstruct";
    rev = "v${param.version}";
    inherit (param) sha256;
  };

  configureFlags = [ "${opt lwt}-lwt" "${opt async_p4}-async" "${opt ppx_tools}-ppx" ];

  buildInputs = [ ocaml findlib ppx_tools camlp4 lwt async_p4 ];
  propagatedBuildInputs = [ ocplib-endian sexplib_p4 ];

  createFindlibDestdir = true;
  dontStrip = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/mirage/ocaml-cstruct;
    description = "Map OCaml arrays onto C-like structs";
    license = stdenv.lib.licenses.isc;
    maintainers = [ maintainers.vbgl maintainers.ericbmerritt ];
    platforms = ocaml.meta.platforms or [];
  };
}
