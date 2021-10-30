{ lib
, buildDunePackage
, letsencrypt
, logs
, fmt
, lwt
, dns
, dns-tsig
, domain-name
}:

buildDunePackage {
  pname = "letsencrypt-dns";

  inherit (letsencrypt)
    version
    src
    useDune2
    minimumOCamlVersion
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
    description = "A DNS solver for the ACME implementation in OCaml";
  };
}
