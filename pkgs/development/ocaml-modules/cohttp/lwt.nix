{ lib, buildDunePackage, cohttp, ocaml_lwt, uri, ppx_sexp_conv, logs, sexplib0 }:

buildDunePackage {
  pname = "cohttp-lwt";
  inherit (cohttp)
    version
    src
    useDune2
    minimumOCamlVersion
    ;

  buildInputs = [ ppx_sexp_conv ];

  propagatedBuildInputs = [
    cohttp ocaml_lwt logs sexplib0 uri
  ];

  meta = cohttp.meta // {
    description = "CoHTTP implementation using the Lwt concurrency library";
  };
}
