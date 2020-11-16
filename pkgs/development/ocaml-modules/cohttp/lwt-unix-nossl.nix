{ buildDunePackage, cohttp-lwt
, conduit-lwt, cmdliner, magic-mime, logs, fmt, ocaml_lwt, ca-certs
, ounit
}:

buildDunePackage {
  pname = "cohttp-lwt-unix-nossl";

  minimumOCamlVersion = "4.08";

  inherit (cohttp-lwt) src version useDune2;

  propagatedBuildInputs = [
    cohttp-lwt conduit-lwt ca-certs cmdliner magic-mime logs fmt ocaml_lwt
  ];

  doCheck = true;
  checkInputs = [ ounit ];

  meta = cohttp-lwt.meta // {
    description = "CoHTTP implementation for Unix and Windows using Lwt";
  };
}
