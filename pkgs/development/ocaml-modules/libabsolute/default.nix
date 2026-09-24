{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  menhir,
  apronext,
  picasso,
}:

buildDunePackage (finalAttrs: {
  pname = "libabsolute";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "mpelleau";
    repo = "absolute";
    tag = finalAttrs.version;
    hash = "sha256-q2QxqZJn71MODJ1+Yf9m33qu8xERTqExMANqgk7aksQ=";
  };

  nativeBuildInputs = [ menhir ];

  propagatedBuildInputs = [
    apronext
    picasso
  ];
  meta = {
    license = lib.licenses.lgpl3Plus;
    homepage = "https://github.com/mpelleau/AbSolute";
    description = "A constraint programming library based on abstract domains";
  };
})
