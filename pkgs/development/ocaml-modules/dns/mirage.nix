{ buildDunePackage, dns, ipaddr, lwt, tcpip }:

buildDunePackage {
  pname = "dns-mirage";

  inherit (dns) version src;
  duneVersion = "3";

  propagatedBuildInputs = [
    dns
    ipaddr
    lwt
    tcpip
  ];

  meta = dns.meta // {
    description = "Opinionated Domain Name System (DNS) library";
  };
}
