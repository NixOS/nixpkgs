{
  buildDunePackage,
  dns,
  dns-client,
  tls-miou-unix,
  happy-eyeballs-miou-unix,
}:

buildDunePackage {
  pname = "dns-client-miou-unix";
  inherit (dns) src version;

  propagatedBuildInputs = [
    dns-client
    tls-miou-unix
    happy-eyeballs-miou-unix
  ];

  doCheck = true;

  meta = dns-client.meta // {
    description = "DNS client API for Miou";
  };
}
