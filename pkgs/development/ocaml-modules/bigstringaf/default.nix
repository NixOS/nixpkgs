{ lib, fetchFromGitHub, buildDunePackage, ocaml, alcotest, bigarray-compat }:

buildDunePackage rec {
  pname = "bigstringaf";
  version = "0.6.0";

  minimumOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = pname;
    rev = version;
    sha256 = "04b088vrqzmxsyan9f9nr8721bxip4b930cgvb5zkbbmrw3ylmwc";
  };

  checkInputs = [ alcotest ];
  propagatedBuildInputs = [ bigarray-compat ];
  doCheck = lib.versionAtLeast ocaml.version "4.05";

  meta = {
    description = "Bigstring intrinsics and fast blits based on memcpy/memmove";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
