{ buildDunePackage, cohttp-lwt, cohttp-lwt-unix-nossl
, conduit-lwt, conduit-lwt-ssl, ca-certs, cmdliner
, magic-mime, logs, fmt, ocaml_lwt
, ounit
}:

buildDunePackage {
  pname = "cohttp-lwt-unix-ssl";

  minimumOCamlVersion = "4.08";

  inherit (cohttp-lwt) src version useDune2;

  propagatedBuildInputs = [
    cohttp-lwt cohttp-lwt-unix-nossl conduit-lwt conduit-lwt-ssl
    ca-certs cmdliner magic-mime logs fmt ocaml_lwt
  ];

  doCheck = true;
  checkInputs = [ ounit ];

  meta = cohttp-lwt.meta // {
    description = "CoHTTP implementation for Unix and Windows using Lwt";
  };
}
