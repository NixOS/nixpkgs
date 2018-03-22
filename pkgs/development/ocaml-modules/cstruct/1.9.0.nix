{ stdenv, writeText, fetchFromGitHub, ocaml, ocamlbuild, ocplib-endian, sexplib, findlib, ppx_tools
, async ? null, lwt ? null
}:

assert stdenv.lib.versionAtLeast ocaml.version "4.01";

let version = "1.9.0"; in

let opt = b: "--${if b != null then "en" else "dis"}able"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-cstruct-${version}";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = "ocaml-cstruct";
    rev = "v${version}";
    sha256 = "1c1j21zgmxi9spq23imy7byn50qr7hlds1cfpzxlsx9dp309jngy";
  };

  configureFlags = [ "${opt lwt}-lwt" "${opt async}-async" "${opt ppx_tools}-ppx" ];

  buildInputs = [ ocaml findlib ocamlbuild ppx_tools lwt async ];
  propagatedBuildInputs = [ ocplib-endian sexplib ];

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
