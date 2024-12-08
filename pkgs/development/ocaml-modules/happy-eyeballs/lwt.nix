{ buildDunePackage
, happy-eyeballs
, cmdliner
, dns
, duration
, domain-name
, ipaddr
, fmt
, logs
, lwt
, mtime
}:

buildDunePackage {
  pname = "happy-eyeballs-lwt";

  inherit (happy-eyeballs) src version;

  minimalOCamlVersion = "4.08";

  buildInputs = [
    cmdliner
    duration
    domain-name
    ipaddr
    fmt
    mtime
  ];

  propagatedBuildInputs = [
    dns
    happy-eyeballs
    logs
    lwt
  ];

  doCheck = true;

  meta = happy-eyeballs.meta // {
    mainProgram = "happy_eyeballs_client";
    description = "Connecting to a remote host via IP version 4 or 6 using Lwt_unix";
  };
}
