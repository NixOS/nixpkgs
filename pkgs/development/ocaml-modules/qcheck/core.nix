{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "qcheck-core";
<<<<<<< HEAD
  version = "0.91";
=======
  version = "0.27";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "qcheck";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-ToF+bRbiq1P5YaGOKiW//onJDhxaxmnaz9/JbJ82OWM=";
=======
    hash = "sha256-UfBfFVSvDeVPUakj2GQCRy5G5IZBxrgdceYtj+VAYbg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    description = "Core qcheck library";
    homepage = "https://c-cube.github.io/qcheck/";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };

})
