{
  buildDunePackage,
  letsencrypt,
  logs,
  fmt,
  lwt,
  dns,
  dns-tsig,
  domain-name,
}:

buildDunePackage {
  pname = "letsencrypt-dns";
  minimalOCamlVersion = "4.08";

  inherit (letsencrypt)
    version
    src
    ;

  propagatedBuildInputs = [
    letsencrypt
    dns
    dns-tsig
    domain-name
    logs
    lwt
    fmt
  ];

  meta = letsencrypt.meta // {
    description = "DNS solver for the ACME implementation in OCaml";
  };
}
