{ lib, buildDunePackage, dns, ocaml_lwt, mirage-clock, mirage-random, mirage-stack, mtime, randomconv }:

buildDunePackage {
  pname = "dns-client";
  inherit (dns) src version;

  propagatedBuildInputs = [ dns mtime ocaml_lwt mirage-clock mirage-random mirage-stack randomconv ];

  meta = dns.meta // {
    description = "Pure DNS resolver API";
  };
}
