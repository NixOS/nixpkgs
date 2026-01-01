{
  lib,
  buildDunePackage,
  dune_3,
  dune-private-libs,
}:

buildDunePackage {
  pname = "dune-glob";
  inherit (dune_3) src version;

  duneVersion = "3";

  dontAddPrefix = true;

  propagatedBuildInputs = [ dune-private-libs ];

  preBuild = ''
    rm -r vendor/csexp
  '';

<<<<<<< HEAD
  meta = {
    inherit (dune_3.meta) homepage;
    description = "Glob string matching language supported by dune";
    maintainers = [ ];
    license = lib.licenses.mit;
=======
  meta = with lib; {
    inherit (dune_3.meta) homepage;
    description = "Glob string matching language supported by dune";
    maintainers = [ ];
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
