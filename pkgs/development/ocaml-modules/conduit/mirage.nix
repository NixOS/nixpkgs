{ buildDunePackage, conduit-lwt
, ppx_sexp_conv, sexplib, cstruct, mirage-stack, mirage-flow
, mirage-flow-combinators, mirage-random, mirage-time, mirage-clock
, dns-client, vchan, xenstore, tls, tls-mirage, ipaddr, ipaddr-sexp
}:

buildDunePackage {
  pname = "conduit-mirage";

  inherit (conduit-lwt) version src minimumOCamlVersion useDune2;

  nativeBuildInputs = [ ppx_sexp_conv ];

  propagatedBuildInputs = [
    sexplib cstruct mirage-stack mirage-clock mirage-flow
    mirage-flow-combinators mirage-random mirage-time
    dns-client conduit-lwt vchan xenstore tls tls-mirage
    ipaddr ipaddr-sexp
  ];

  meta = conduit-lwt.meta // {
    description = "A network connection establishment library for MirageOS";
  };
}
