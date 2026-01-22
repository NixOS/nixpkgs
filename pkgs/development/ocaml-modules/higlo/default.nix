{
  lib,
  buildDunePackage,
  fetchFromGitLab,
  sedlex,
  xtmpl,
}:

buildDunePackage (finalAttrs: {
  pname = "higlo";
  version = "0.10.0";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "zoggy";
    repo = "higlo";
    rev = finalAttrs.version;
    hash = "sha256-A5Su4+eBOq/WNdY/3EBQ3KqrRQuaCI1x25cEuoZp4Mo=";
  };

  propagatedBuildInputs = [
    sedlex
    xtmpl
  ];

  meta = {
    description = "OCaml library for syntax highlighting";
    inherit ((finalAttrs.src.meta)) homepage;
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ regnat ];
  };
})
