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

<<<<<<< HEAD
  meta = {
    inherit (dune-action-plugin.meta) homepage;
    description = "Embed build information inside executables";
    maintainers = [ lib.maintainers.bcdarwin ];
    license = lib.licenses.mit;
=======
  meta = with lib; {
    inherit (dune-action-plugin.meta) homepage;
    description = "Embed build information inside executables";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
