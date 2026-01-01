{
  lib,
  buildDunePackage,
<<<<<<< HEAD
  dune,
=======
  dune_3,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildDunePackage {
  pname = "xdg";
<<<<<<< HEAD
  inherit (dune) src version;

  dontAddPrefix = true;

  meta = {
    description = "XDG Base Directory Specification";
    inherit (dune.meta) homepage maintainers;
    license = lib.licenses.mit;
=======
  inherit (dune_3) src version;

  duneVersion = "3";
  minimalOCamlVersion = "4.08";

  dontAddPrefix = true;

  meta = with lib; {
    description = "XDG Base Directory Specification";
    inherit (dune_3.meta) homepage;
    maintainers = [ ];
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
