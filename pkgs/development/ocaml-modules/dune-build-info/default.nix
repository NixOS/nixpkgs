{
  lib,
  buildDunePackage,
  dune-action-plugin,
}:

buildDunePackage {
  pname = "dune-build-info";
  inherit (dune-action-plugin) src version preBuild;

  dontAddPrefix = true;

  buildInputs = [ dune-action-plugin ];

  meta = with lib; {
    inherit (dune-action-plugin.meta) homepage;
    description = "Embed build information inside executables";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.mit;
  };
}
