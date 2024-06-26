{
  lib,
  buildDunePackage,
  dns,
  dns-client,
  lwt,
  mirage-clock,
  mirage-time,
  mirage-random,
  mirage-crypto-rng,
  mtime,
  randomconv,
  cstruct,
  fmt,
  logs,
  rresult,
  domain-name,
  ipaddr,
  alcotest,
  ca-certs,
  ca-certs-nss,
  happy-eyeballs,
  tcpip,
  tls,
  tls-mirage,
}:

buildDunePackage {
  pname = "dns-client-mirage";
  inherit (dns) src version;
  duneVersion = "3";

  propagatedBuildInputs = [
    dns-client
    domain-name
    ipaddr
    lwt
    mirage-random
    mirage-time
    mirage-clock
    ca-certs-nss
    happy-eyeballs
    tcpip
    tls
    tls-mirage
  ];
  doCheck = true;

  meta = dns-client.meta;
}
