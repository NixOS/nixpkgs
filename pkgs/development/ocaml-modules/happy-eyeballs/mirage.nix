{ buildDunePackage
, happy-eyeballs
, dns-client
, logs
, lwt
, tcpip
}:

buildDunePackage {
  pname = "happy-eyeballs-mirage";
  inherit (happy-eyeballs) src version;

  propagatedBuildInputs = [
    dns-client
    happy-eyeballs
    logs
    lwt
    tcpip
  ];

  meta = happy-eyeballs.meta // {
    description = "Connecting to a remote host via IP version 4 or 6 using Mirage";
  };

}
