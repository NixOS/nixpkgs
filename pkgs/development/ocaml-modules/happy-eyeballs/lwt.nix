{ buildDunePackage
, happy-eyeballs
, cmdliner
, dns-client
, logs
, lwt
}:

buildDunePackage {
  pname = "happy-eyeballs-lwt";
  inherit (happy-eyeballs) src version;

  buildInputs = [ cmdliner ];

  propagatedBuildInputs = [
    dns-client
    happy-eyeballs
    logs
    lwt
  ];

  meta = happy-eyeballs.meta // {
    description = "Connecting to a remote host via IP version 4 or 6 using Lwt_unix";
  };

}
