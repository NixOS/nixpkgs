{
  buildDunePackage,
  asn1-combinators,
  astring,
  base64,
  capnp,
  capnp-rpc,
  capnproto,
  cstruct,
  fmt,
  logs,
  mirage-crypto,
  mirage-crypto-rng,
  prometheus,
  ptime,
  tls-eio,
  uri,
  x509,
}:

buildDunePackage (finalAttrs: {
  pname = "capnp-rpc-net";

  minimalOCamlVersion = "5.2";

  inherit (capnp-rpc) src version;

  nativeBuildInputs = [
    capnproto
  ];

  propagatedBuildInputs = [
    asn1-combinators
    astring
    base64
    capnp
    capnp-rpc
    cstruct
    fmt
    logs
    mirage-crypto
    mirage-crypto-rng
    prometheus
    ptime
    tls-eio
    uri
    x509
  ];

  meta = capnp-rpc.meta // {
    description = "Network and TLS support for Cap'n Proto RPC services";
  };
})
