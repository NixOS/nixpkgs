{ lib, fetchFromGitHub, buildDunePackage, ocaml, alcotest, bigarray-compat, pkg-config }:

buildDunePackage rec {
  pname = "bigstringaf";
  version = "0.9.0";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = pname;
    rev = version;
    sha256 = "sha256-HXPjnE56auy2MI6HV2XuBX/VeqsO50HFzTul17lKEqE=";
  };

  nativeBuildInputs = [ pkg-config ];
  checkInputs = [ alcotest ];
  doCheck = true;

  meta = {
    description = "Bigstring intrinsics and fast blits based on memcpy/memmove";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
