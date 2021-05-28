{ lib, buildDunePackage, fetchFromGitHub, qcheck }:

buildDunePackage rec {
  pname = "qtest";
  version = "2.11";

  src = fetchFromGitHub {
    owner = "vincent-hugot";
    repo = pname;
    rev = "v${version}";
    sha256 = "10fi2093ny8pp3jsi1gdqsllp3lr4r5mfcs2hrm7qvbnhrdbb0g3";
  };

  propagatedBuildInputs = [ qcheck ];

  meta = {
    description = "Inline (Unit) Tests for OCaml";
    inherit (src.meta) homepage;
    maintainers = with lib.maintainers; [ vbgl ];
    license = lib.licenses.gpl3;
  };
}
