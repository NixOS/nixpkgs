{ lib, buildDunePackage, posix-base }:

buildDunePackage {
  pname = "posix-types";

  inherit (posix-base) version src;

  minimalOCamlVersion = "4.03";
  duneVersion = "3";

  propagatedBuildInputs = [ posix-base ];

  meta = posix-base.meta // {
    description = "Bindings for the types defined in <sys/types.h>";
  };
}
