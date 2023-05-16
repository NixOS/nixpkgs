<<<<<<< HEAD
{ buildDunePackage, camlp-streams, xenstore_transport, xenstore, lwt }:
=======
{ buildDunePackage, xenstore_transport, xenstore, lwt }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildDunePackage {
  pname = "xenstore-tool";

  inherit (xenstore_transport) src version;

<<<<<<< HEAD
  postPatch = ''
    substituteInPlace cli/dune --replace 'libraries ' 'libraries camlp-streams '
  '';

  buildInputs = [ camlp-streams xenstore_transport xenstore lwt ];
=======
  duneVersion = "3";

  buildInputs = [ xenstore_transport xenstore lwt ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = xenstore_transport.meta // {
    description = "Command line tool for interfacing with xenstore";
  };
}
