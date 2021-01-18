{ lib, fetchFromGitHub, buildDunePackage }:

buildDunePackage rec {
  pname = "safepass";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "darioteixeira";
    repo = "ocaml-safepass";
    rev = "v${version}";
    sha256 = "0i127gs9x23wzwa1q3dxa2j6hby07hvxdg1c98fc3j09rg6vy2bs";
  };

  meta = {
    inherit (src.meta) homepage;
    description = "An OCaml library offering facilities for the safe storage of user passwords";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ vbgl ];
  };

}
