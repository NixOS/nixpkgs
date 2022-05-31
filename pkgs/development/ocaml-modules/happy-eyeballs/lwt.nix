{ lib, buildDunePackage
, happy-eyeballs, cmdliner, duration, dns-client
, domain-name, ipaddr, fmt, logs, lwt, mtime
}:

buildDunePackage {
  pname = "happy-eyeballs-lwt";

  inherit (happy-eyeballs) src version;

  minimumOCamlVersion = "4.08";

  strictDeps = true;

  buildInputs = [
    happy-eyeballs
    cmdliner
    duration
    dns-client
    domain-name
    ipaddr
    fmt
    logs
    lwt
    mtime
  ];
  doCheck = false;

  meta = happy-eyeballs.meta;
}
