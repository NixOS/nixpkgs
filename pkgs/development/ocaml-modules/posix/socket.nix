{ lib, buildDunePackage, posix-base }:

buildDunePackage {
  pname = "posix-socket";

  inherit (posix-base) version src;

  duneVersion = "3";

  propagatedBuildInputs = [ posix-base ];

  doCheck = true;

  meta = posix-base.meta // {
    description = "Bindings for posix sockets";
  };

}
