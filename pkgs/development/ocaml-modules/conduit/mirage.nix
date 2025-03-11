{
  buildDunePackage,
  conduit-lwt,
  ppx_sexp_conv,
  sexplib0,
  uri,
  cstruct,
  mirage-flow,
  mirage-flow-combinators,
  mirage-crypto-rng-mirage,
  mirage-time,
  mirage-clock,
  dns-client-mirage,
  vchan,
  xenstore,
  tls,
  tls-mirage,
  ipaddr,
  ipaddr-sexp,
  tcpip,
  ca-certs-nss,
}:

buildDunePackage {
  pname = "conduit-mirage";

  inherit (conduit-lwt) version src;

  nativeBuildInputs = [ ppx_sexp_conv ];

  propagatedBuildInputs = [
    sexplib0
    uri
    cstruct
    mirage-clock
    mirage-flow
    mirage-flow-combinators
    mirage-crypto-rng-mirage
    mirage-time
    dns-client-mirage
    conduit-lwt
    vchan
    xenstore
    tls
    tls-mirage
    ipaddr
    ipaddr-sexp
    tcpip
    ca-certs-nss
  ];

  meta = conduit-lwt.meta // {
    description = "Network connection establishment library for MirageOS";
  };
}
