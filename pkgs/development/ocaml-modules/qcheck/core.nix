{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "qcheck-core";
  version = "0.91";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "qcheck";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ToF+bRbiq1P5YaGOKiW//onJDhxaxmnaz9/JbJ82OWM=";
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
