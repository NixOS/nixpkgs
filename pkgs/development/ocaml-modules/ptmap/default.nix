{
  lib,
  buildDunePackage,
  fetchurl,
  seq,
  stdlib-shims,
}:

buildDunePackage (finalAttrs: {
  pname = "ptmap";
  version = "2.0.5";

  src = fetchurl {
    url = "https://github.com/backtracking/ptmap/releases/download/${finalAttrs.version}/ptmap-${finalAttrs.version}.tbz";
    hash = "sha256-69H4r+hnmiJv3LzbMjeI5vY9tXUhsVFHPy/4wFww86o=";
  };

  buildInputs = [ stdlib-shims ];
  propagatedBuildInputs = [ seq ];

  doCheck = true;

  meta = {
    homepage = "https://www.lri.fr/~filliatr/software.en.html";
    description = "Maps over integers implemented as Patricia trees";
    license = lib.licenses.lgpl21;
    maintainers = [ ];
  };
})
