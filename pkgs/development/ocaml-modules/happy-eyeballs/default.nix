{
  lib,
  buildDunePackage,
  fetchurl,
  domain-name,
  duration,
  fmt,
  ipaddr,
  logs,
}:

buildDunePackage rec {
  pname = "happy-eyeballs";
  version = "1.2.2";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/roburio/happy-eyeballs/releases/download/v${version}/happy-eyeballs-${version}.tbz";
    hash = "sha256-Cl0CZwQMwrmwMaidfqp8PyG57rYV2VOUVVW9ECVlLq8=";
  };

  propagatedBuildInputs = [
    domain-name
    duration
    fmt
    ipaddr
    logs
  ];

  meta = with lib; {
    description = "Connecting to a remote host via IP version 4 or 6";
    homepage = "https://github.com/roburio/happy-eyeballs";
    license = licenses.isc;
    maintainers = with maintainers; [
      vbgl
      ulrikstrid
    ];
  };
}
