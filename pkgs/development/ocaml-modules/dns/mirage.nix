{ buildDunePackage, dns, ipaddr, lwt, tcpip }:

buildDunePackage {
  pname = "dns-mirage";

  inherit (dns) version src;

  propagatedBuildInputs = [
    dns
    ipaddr
    lwt
    tcpip
  ];

  meta = dns.meta // {
    description = "An opinionated Domain Name System (DNS) library";
  };
}
