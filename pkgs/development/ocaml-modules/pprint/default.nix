{
  lib,
  fetchFromGitHub,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "pprint";
  version = "20230830";

  minimalOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "fpottier";
    repo = pname;
    rev = version;
    sha256 = "sha256-avf71vAgCL1MU8O7Q3FNN3wEdCDtbNZP0ipETnn8AqA=";
  };

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "An OCaml library for pretty-printing textual documents";
    license = licenses.lgpl2Only;
    maintainers = [ maintainers.vbgl ];
  };
}
