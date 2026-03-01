{
  lib,
  buildDunePackage,
  fetchFromGitLab,
  yojson,
}:

buildDunePackage (finalAttrs: {
  pname = "ocf";
  version = "0.9.0";
  patches = ./yojson.patch;
  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "zoggy";
    repo = "ocf";
    tag = finalAttrs.version;
    hash = "sha256-tTNpvncLO/WfcMbjqRfqzcdPv2Bd877fOU5AZlkkcXA=";
  };

  propagatedBuildInputs = [ yojson ];

  meta = {
    description = "OCaml library to read and write configuration options in JSON syntax";
    homepage = "https://zoggy.frama.io/ocf/";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ regnat ];
  };
})
