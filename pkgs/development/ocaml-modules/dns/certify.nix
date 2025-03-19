{
  buildDunePackage,
  dns,
  dns-tsig,
  dns-mirage,
  randomconv,
  x509,
  mirage-sleep,
  mirage-ptime,
  logs,
  mirage-crypto-pk,
  mirage-crypto-rng,
  mirage-crypto-ec,
  lwt,
  tcpip,
}:

buildDunePackage {
  pname = "dns-certify";

  inherit (dns) version src;

  propagatedBuildInputs = [
    dns
    dns-tsig
    dns-mirage
    randomconv
    x509
    mirage-sleep
    mirage-ptime
    logs
    mirage-crypto-pk
    mirage-crypto-rng
    mirage-crypto-ec
    lwt
    tcpip
  ];

  doCheck = true;

  meta = dns.meta // {
    description = "MirageOS let's encrypt certificate retrieval";
  };
}
