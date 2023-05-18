{ lib, buildDunePackage, fetchFromGitHub }:

buildDunePackage rec {
  pname = "camlp-streams";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kHuFBqu0mjFv53sOtmFZcX2reo5ToaOpItP7P53bfGQ=";
  };

  meta = {
    description = "Stream and Genlex libraries for use with Camlp4 and Camlp5";
    license = lib.licenses.lgpl21Only;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
