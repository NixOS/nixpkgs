{ lib, fetchFromGitLab, buildDunePackage, ocaml, zarith, alcotest }:

buildDunePackage rec {
  pname = "ff";
  version = "0.4.0";

  src = fetchFromGitLab {
    owner = "dannywillems";
    repo = "ocaml-ff";
    rev = version;
    sha256 = "1ik29srzkd0pl48p1si9p1c4f8vmx5rgm02yv2arj3vg0a1nfhdv";
  };

  useDune2 = true;

  propagatedBuildInputs = [
    zarith
  ];

  checkInputs = [
    alcotest
  ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = {
    homepage = "https://gitlab.com/dannywillems/ocaml-ff";
    description = "OCaml implementation of Finite Field operations";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
