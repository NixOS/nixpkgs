{ lib, fetchFromGitHub, buildDunePackage, ocaml, alcotest, bigarray-compat, pkg-config }:

buildDunePackage rec {
  pname = "bigstringaf";
  version = "0.9.0";

  useDune2 = true;

  minimumOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = pname;
    rev = version;
    sha256 = "188j9awxg99vrp2l3rqfmdxdazq5xrjmg1wf62vfqsks9sff6wqx";
  };

  # This currently fails with dune
  strictDeps = false;

  nativeBuildInputs = [ pkg-config ];
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
