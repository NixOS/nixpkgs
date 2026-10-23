{
  lib,
  fetchFromGitHub,
  buildDunePackage,
}:

buildDunePackage (finalAttrs: {
  pname = "safepass";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "darioteixeira";
    repo = "ocaml-safepass";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uOhP6MMN5yitNOHu0OVlq8Vd/UySMgaro+ScsBqnmrM=";
  };

  meta = {
    homepage = "https://github.com/darioteixeira/ocaml-safepass";
    description = "OCaml library offering facilities for the safe storage of user passwords";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ vbgl ];
  };

})
