{ lib, buildDunePackage, dune_2 }:

buildDunePackage rec {
  pname = "dune-build-info";
  inherit (dune_2) src version;

  useDune2 = true;

  dontAddPrefix = true;

  meta = with lib; {
    inherit (dune_2.meta) homepage;
    description = "Embed build information inside executables";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.mit;
  };
}
