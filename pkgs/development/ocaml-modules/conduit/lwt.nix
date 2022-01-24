{ buildDunePackage, ppx_sexp_conv, conduit, ocaml_lwt, sexplib }:

buildDunePackage {
  pname = "conduit-lwt";
  inherit (conduit) version src useDune2 minimumOCamlVersion;

  buildInputs = [ ppx_sexp_conv ];

  propagatedBuildInputs = [ conduit ocaml_lwt sexplib ];

  meta = conduit.meta // {
    description = "A network connection establishment library for Lwt";
  };
}
