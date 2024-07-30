{ buildDunePackage, dns
, mirage-crypto-rng, mtime, randomconv
, domain-name, alcotest
}:

buildDunePackage {
  pname = "dns-client";
  inherit (dns) src version;
  duneVersion = "3";

  propagatedBuildInputs = [
    dns
    randomconv
    domain-name
    mtime
    mirage-crypto-rng
  ];
  checkInputs = [ alcotest ];
  doCheck = true;

  meta = dns.meta // {
    description = "Pure DNS resolver API";
    mainProgram = "dns-client.unix";
  };
}
