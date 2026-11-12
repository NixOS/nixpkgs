{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage (finalAttrs: {
  pname = "path_glob";
  version = "0.3";
  src = fetchurl {
    url = "https://gasche.gitlab.io/path_glob/releases/path_glob-${finalAttrs.version}.tgz";
    hash = "sha256-My2uI7cA+gUNH9bk89LiS43R2yyOpPdsVOLlSFHJ0iY=";
  };

  meta = {
    homepage = "https://gitlab.com/gasche/path_glob";
    description = "Checking glob patterns on paths";
    license = lib.licenses.lgpl2Only;
  };
})
