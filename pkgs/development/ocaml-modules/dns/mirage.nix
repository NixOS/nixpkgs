{
  buildDunePackage,
  dns,
  cstruct,
  ipaddr,
  lwt,
  tcpip,
}:

buildDunePackage {
  pname = "dns-mirage";

  inherit (dns) version src;

  propagatedBuildInputs = [
    cstruct
    dns
    ipaddr
    lwt
    tcpip
  ];

  meta = dns.meta // {
    description = "Opinionated Domain Name System (DNS) library";
  };
}
