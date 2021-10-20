{ buildDunePackage, xenstore_transport, xenstore, lwt }:

buildDunePackage {
  pname = "xenstore-tool";

  inherit (xenstore_transport) src version useDune2 minimumOCamlVersion;

  buildInputs = [ xenstore_transport xenstore lwt ];

  meta = xenstore_transport.meta // {
    description = "Command line tool for interfacing with xenstore";
  };
}
