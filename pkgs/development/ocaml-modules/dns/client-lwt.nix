{ buildDunePackage, dns, dns-client, lwt
, mirage-crypto-rng, mtime
, ipaddr, alcotest
, ca-certs
, happy-eyeballs
, tls-lwt
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
