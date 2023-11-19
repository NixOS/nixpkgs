{ buildDunePackage, conduit-lwt
, fetchpatch
, ppx_sexp_conv, sexplib, uri, cstruct, mirage-flow
, mirage-flow-combinators, mirage-random, mirage-time, mirage-clock
, dns-client-mirage, vchan, xenstore, tls, tls-mirage, ipaddr, ipaddr-sexp
, tcpip, ca-certs-nss
}:

buildDunePackage {
  pname = "conduit-mirage";

  inherit (conduit-lwt) version src;

  # Compatibility with tls ≥ 0.17
  patches = fetchpatch {
    url = "https://github.com/mirage/ocaml-conduit/commit/403b4cec528dae71aded311215868a35c11dad7e.patch";
    hash = "sha256-R/iuLf2PSrx8mLKLueMA3+zr9sB8dX/3evjUbfQECBk=";
  };

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
