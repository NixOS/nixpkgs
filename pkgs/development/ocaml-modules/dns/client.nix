{ lib, buildDunePackage, dns, ocaml_lwt, mirage-clock, mirage-time
, mirage-random, mirage-stack, mirage-crypto-rng, mtime, randomconv }:

buildDunePackage {
  pname = "dns-client";
  inherit (dns) src version;

  useDune2 = true;

  propagatedBuildInputs = [ dns mtime ocaml_lwt randomconv mirage-clock mirage-time
                            mirage-random mirage-stack mirage-crypto-rng ];

  meta = dns.meta // {
    description = "Pure DNS resolver API";
  };
}
