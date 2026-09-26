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

  propagatedBuildInputs = [
    domain-name
    duration
    fmt
    happy-eyeballs
    ipaddr
    logs
    lwt
    mirage-mtime
    mirage-sleep
    tcpip
  ];

  doCheck = true;

  meta = happy-eyeballs.meta // {
    description = "Connecting to a remote host via IP version 4 or 6 using Mirage";
  };
}
