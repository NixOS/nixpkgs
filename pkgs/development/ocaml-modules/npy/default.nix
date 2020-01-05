{ lib, buildDunePackage, fetchFromGitHub, numpy, camlzip }:

buildDunePackage rec {
  pname = "npy";
  version = "unstable-2019-04-02";

  minimumOCamlVersion = "4.06";

  src = fetchFromGitHub {
    owner = "LaurentMazare";
    repo   = "${pname}-ocaml";
    rev    = "c051086bfea6bee58208098bcf1c2f725a80a1fb";
    sha256 = "06mgrnm7xiw2lhqvbdv2zmd65sqfdnjd7j4qmcswanmplm17yhvb";
  };

  propagatedBuildInputs = [ camlzip ];
  checkInputs = [ numpy ];

  doCheck = true;

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "OCaml implementation of the Npy format spec";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.asl20;
  };
}
