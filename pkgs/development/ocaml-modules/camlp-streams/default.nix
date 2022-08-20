{ lib, buildDunePackage, fetchFromGitHub }:

buildDunePackage rec {
  pname = "camlp-streams";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256:1wd5k0irzwi841b27pbx0n5fdybbgx97184zm8cjajizd2j8w0g5";
  };

  meta = {
    description = "Stream and Genlex libraries for use with Camlp4 and Camlp5";
    license = lib.licenses.lgpl21Only;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
