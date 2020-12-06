{ lib, buildDunePackage, dns, ocaml_lwt, mirage-clock, mirage-time
, mirage-random, mirage-stack, mirage-crypto-rng, mtime, randomconv
, cstruct, fmt, logs, rresult, domain-name, ipaddr, alcotest }:

buildDunePackage {
  pname = "dns-client";
  inherit (dns) src version;

  useDune2 = true;

  propagatedBuildInputs = [ cstruct fmt logs dns rresult randomconv domain-name ipaddr
                            ocaml_lwt mirage-stack mirage-random mirage-time mirage-clock
                            mtime mirage-crypto-rng ];
  checkInputs = [ alcotest ];
  doCheck = true;

  meta = dns.meta // {
    description = "Pure DNS resolver API";
  };
}
