{ lib, buildDunePackage, dune_2, dune-action-plugin }:

buildDunePackage rec {
  pname = "dune-build-info";
  inherit (dune_2) src version patches;

  useDune2 = true;

  dontAddPrefix = true;

  buildInputs = [ dune-action-plugin ];

  meta = with lib; {
    inherit (dune_2.meta) homepage;
    description = "Embed build information inside executables";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.mit;
  };
}
