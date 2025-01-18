{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  alcotest,
  pkg-config,
}:

buildDunePackage rec {
  pname = "bigstringaf";
  version = "0.9.0";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = pname;
    rev = version;
    hash = "sha256-HXPjnE56auy2MI6HV2XuBX/VeqsO50HFzTul17lKEqE=";
  };

  nativeBuildInputs = [ pkg-config ];
  checkInputs = [ alcotest ];
  doCheck = true;

  meta = with lib; {
    description = "Bigstring intrinsics and fast blits based on memcpy/memmove";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
