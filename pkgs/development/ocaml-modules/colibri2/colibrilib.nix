{
  lib,
  buildDunePackage,
  fetchFromGitLab,

  zarith,
}:

buildDunePackage (finalAttrs: {
  pname = "colibrilib";
  version = "0.6";

  src = fetchFromGitLab {
    owner = "pub";
    repo = "colibrics";
    domain = "git.frama-c.com";
    tag = finalAttrs.version;
    hash = "sha256-xuPFXonA6O/G+14Y3eglBTAtauBPewyYX9OXfEIe/6g=";
  };

  propagatedBuildInputs = [
    zarith
  ];

  meta = {
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ luc65r ];
  };
})
