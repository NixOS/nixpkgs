{
  buildDunePackage,
  happy-eyeballs,
  cmdliner,
  duration,
  domain-name,
  fmt,
  ipaddr,
  logs,
  miou,
  mtime,
}:

buildDunePackage {
  pname = "happy-eyeballs-miou-unix";
  inherit (happy-eyeballs) src version;

  buildInputs = [
    cmdliner
    duration
    domain-name
    fmt
    logs
  ];

  propagatedBuildInputs = [
    happy-eyeballs
    ipaddr
    miou
    mtime
  ];

  doCheck = true;

  meta = happy-eyeballs.meta // {
    description = "Connecting to a remote host via IP version 4 or 6 using Miou";
  };
}
