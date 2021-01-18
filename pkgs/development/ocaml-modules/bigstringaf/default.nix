{ lib, fetchFromGitHub, buildDunePackage, ocaml, alcotest, bigarray-compat }:

buildDunePackage rec {
  pname = "bigstringaf";
  version = "0.7.0";

  useDune2 = true;

  minimumOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = pname;
    rev = version;
    sha256 = "1q1sqxzdnlrpl95ccrhl7lwy3zswgd9rbn19ildclh0lyi2vazbj";
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
