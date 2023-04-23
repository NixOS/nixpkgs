{ buildDunePackage
, conduit-lwt, ppx_sexp_conv, lwt, uri, ipaddr, ipaddr-sexp, ca-certs, logs
, lwt_ssl, tls, lwt_log, ssl
}:

buildDunePackage {
  pname = "conduit-lwt-unix";
  inherit (conduit-lwt) version src;
  duneVersion = "3";

  buildInputs = [ ppx_sexp_conv ];

  propagatedBuildInputs = [
    conduit-lwt
    lwt
    uri
    ipaddr
    ipaddr-sexp
    tls
    ca-certs
    logs
    lwt_ssl
  ];

  doCheck = true;
  checkInputs = [
    lwt_log
    ssl
  ];

  meta = conduit-lwt.meta // {
    description = "A network connection establishment library for Lwt_unix";
  };
}
