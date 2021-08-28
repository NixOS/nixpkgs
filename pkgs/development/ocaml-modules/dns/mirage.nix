{ buildDunePackage, dns, mirage-stack, ipaddr, lwt }:

buildDunePackage {
  pname = "dns-mirage";

  inherit (dns) version src useDune2 minimumOCamlVersion;

  propagatedBuildInputs = [
    dns
    mirage-stack
    ipaddr
    lwt
  ];

  meta = dns.meta // {
    description = "An opinionated Domain Name System (DNS) library";
  };
}
