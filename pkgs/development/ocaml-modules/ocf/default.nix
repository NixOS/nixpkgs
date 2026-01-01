{
  lib,
  buildDunePackage,
  fetchFromGitLab,
  yojson,
}:

<<<<<<< HEAD
buildDunePackage (finalAttrs: {
  pname = "ocf";
  version = "0.9.0";
  patches = ./yojson.patch;
=======
buildDunePackage rec {
  pname = "ocf";
  version = "0.9.0";
  duneVersion = "3";
  minimalOCamlVersion = "4.03";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "zoggy";
    repo = "ocf";
<<<<<<< HEAD
    tag = finalAttrs.version;
    hash = "sha256-tTNpvncLO/WfcMbjqRfqzcdPv2Bd877fOU5AZlkkcXA=";
=======
    rev = version;
    sha256 = "sha256-tTNpvncLO/WfcMbjqRfqzcdPv2Bd877fOU5AZlkkcXA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  propagatedBuildInputs = [ yojson ];

<<<<<<< HEAD
  meta = {
    description = "OCaml library to read and write configuration options in JSON syntax";
    homepage = "https://zoggy.frama.io/ocf/";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ regnat ];
  };
})
=======
  meta = with lib; {
    description = "OCaml library to read and write configuration options in JSON syntax";
    homepage = "https://zoggy.frama.io/ocf/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ regnat ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
