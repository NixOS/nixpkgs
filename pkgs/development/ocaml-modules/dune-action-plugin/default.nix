{
  lib,
  buildDunePackage,
  dune_3,
  dune-glob,
  dune-private-libs,
  dune-rpc,
}:

buildDunePackage {
  pname = "dune-action-plugin";
  inherit (dune_3) src version;

  duneVersion = "3";

  dontAddPrefix = true;

  propagatedBuildInputs = [
    dune-glob
    dune-private-libs
    dune-rpc
  ];

  preBuild = ''
    rm -r vendor/csexp
  '';

<<<<<<< HEAD
  meta = {
    inherit (dune_3.meta) homepage;
    description = "API for writing dynamic Dune actions";
    maintainers = [ ];
    license = lib.licenses.mit;
=======
  meta = with lib; {
    inherit (dune_3.meta) homepage;
    description = "API for writing dynamic Dune actions";
    maintainers = [ ];
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
