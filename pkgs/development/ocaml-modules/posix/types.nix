{ buildDunePackage, posix-base }:

buildDunePackage {
  pname = "posix-types";

  inherit (posix-base) version src;

  propagatedBuildInputs = [ posix-base ];

  meta = posix-base.meta // {
    description = "Bindings for the types defined in <sys/types.h>";
  };
}
