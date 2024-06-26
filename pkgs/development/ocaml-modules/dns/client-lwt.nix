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
  tls-lwt,
}:

buildDunePackage {
  pname = "dns-client-lwt";
  inherit (dns) src version;
  duneVersion = "3";

  propagatedBuildInputs = [
    dns
    dns-client
    ipaddr
    lwt
    ca-certs
    happy-eyeballs
    tls-lwt
    mtime
    mirage-crypto-rng
  ];
  checkInputs = [ alcotest ];
  doCheck = true;

  meta = dns-client.meta;
}
