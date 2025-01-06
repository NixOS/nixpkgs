{
  buildDunePackage,
  dns,
  dns-client,
  lwt,
  mirage-clock,
  mirage-time,
  mirage-crypto-rng-mirage,
  domain-name,
  ipaddr,
  ca-certs-nss,
  happy-eyeballs,
  happy-eyeballs-mirage,
  tcpip,
  tls,
  tls-mirage,
}:

buildDunePackage {
  pname = "dns-client-mirage";
  inherit (dns) src version;

  propagatedBuildInputs = [
    dns-client
    domain-name
    ipaddr
    lwt
    mirage-crypto-rng-mirage
    mirage-time
    mirage-clock
    ca-certs-nss
    happy-eyeballs
    happy-eyeballs-mirage
    tcpip
    tls
    tls-mirage
  ];
  doCheck = true;

  meta = dns-client.meta;
}
