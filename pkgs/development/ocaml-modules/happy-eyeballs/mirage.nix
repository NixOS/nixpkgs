{
  buildDunePackage,
  happy-eyeballs,
  duration,
  domain-name,
  ipaddr,
  fmt,
  logs,
  lwt,
  mirage-mtime,
  mirage-sleep,
  tcpip,
}:

buildDunePackage {
  pname = "happy-eyeballs-mirage";

  inherit (happy-eyeballs) src version;

  minimalOCamlVersion = "4.08";

  buildInputs = [
    duration
    ipaddr
    domain-name
    fmt
    mirage-mtime
    mirage-sleep
  ];

  propagatedBuildInputs = [
    happy-eyeballs
    logs
    lwt
    tcpip
  ];

  doCheck = true;

  meta = happy-eyeballs.meta // {
    description = "Connecting to a remote host via IP version 4 or 6 using Mirage";
  };
}
