{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "qcheck-core";
  version = "0.27";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "qcheck";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UfBfFVSvDeVPUakj2GQCRy5G5IZBxrgdceYtj+VAYbg=";
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
