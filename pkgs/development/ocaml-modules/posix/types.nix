{ lib, buildDunePackage, posix-base }:

buildDunePackage {
  pname = "posix-types";

  inherit (posix-base) version src useDune2;

  minimumOCamlVersion = "4.03";

  propagatedBuildInputs = [ posix-base ];

  meta = posix-base.meta // {
    description = "Bindings for the types defined in <sys/types.h>";
  };
}
