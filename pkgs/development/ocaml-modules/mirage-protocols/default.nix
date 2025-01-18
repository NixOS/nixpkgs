{
  lib,
  buildDunePackage,
  fetchurl,
  arp,
  ethernet,
  ipaddr,
  tcpip,
}:

buildDunePackage rec {
  pname = "mirage-protocols";
  version = "8.0.0";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-protocols/releases/download/v${version}/mirage-protocols-v${version}.tbz";
    hash = "sha256-UDCR4Jq3tw9P/Ilw7T4+3+yi9Q7VFqnHhXeSCvg9dyw=";
  };

  propagatedBuildInputs = [
    arp
    ethernet
    ipaddr
    tcpip
  ];

  meta = with lib; {
    description = "MirageOS signatures for network protocols";
    homepage = "https://github.com/mirage/mirage-protocols";
    license = licenses.isc;
    maintainers = [ maintainers.vbgl ];
  };
}
