{ buildDunePackage, conduit-lwt
, ppx_sexp_conv, sexplib, uri, cstruct, mirage-flow
, mirage-flow-combinators, mirage-random, mirage-time, mirage-clock
, dns-client-mirage, vchan, xenstore, tls, tls-mirage, ipaddr, ipaddr-sexp
, tcpip, ca-certs-nss
}:

buildDunePackage {
  pname = "conduit-mirage";

  inherit (conduit-lwt) version src;

  nativeBuildInputs = [ ppx_sexp_conv ];

  propagatedBuildInputs = [
    sexplib uri cstruct mirage-clock mirage-flow
    mirage-flow-combinators mirage-random mirage-time
    dns-client-mirage conduit-lwt vchan xenstore tls tls-mirage
    ipaddr ipaddr-sexp tcpip ca-certs-nss
  ];

  meta = conduit-lwt.meta // {
    description = "A network connection establishment library for MirageOS";
  };
}
