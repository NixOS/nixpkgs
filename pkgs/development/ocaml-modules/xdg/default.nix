{
  lib,
  buildDunePackage,
  dune,
}:

buildDunePackage {
  pname = "xdg";
  inherit (dune) src version;

  dontAddPrefix = true;

  meta = {
    description = "XDG Base Directory Specification";
    inherit (dune.meta) homepage maintainers;
    license = lib.licenses.mit;
  };
}
