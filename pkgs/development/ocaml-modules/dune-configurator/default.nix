{
  lib,
  buildDunePackage,
  dune_3,
  csexp,
}:

buildDunePackage {
  pname = "dune-configurator";

  inherit (dune_3) src version patches;

  # This fixes finding csexp
  postPatch = ''
    rm -rf vendor/pp vendor/csexp
  '';

  minimalOCamlVersion = "4.05";

  dontAddPrefix = true;

  propagatedBuildInputs = [ csexp ];

<<<<<<< HEAD
  meta = {
    description = "Helper library for gathering system configuration";
    maintainers = [ ];
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Helper library for gathering system configuration";
    maintainers = [ ];
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
