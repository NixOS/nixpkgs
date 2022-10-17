{ lib, fetchFromGitLab, buildDunePackage, ocaml, bigstring, alcotest, cstruct, hex }:

buildDunePackage rec {
  pname = "uecc";
  version = "0.3";

  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "ocaml-uecc";
    rev = "v${version}";
    sha256 = "0m3cw34254baajscrwlrj0jp5n0yad3dhgi4jh3pz89iqykj15fr";
  };

  useDune2 = true;

  propagatedBuildInputs = [
    bigstring
  ];

  checkInputs = [
    alcotest
    cstruct
    hex
  ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = {
    description = "Bindings for ECDH and ECDSA for 8-bit, 32-bit, and 64-bit processors";
    homepage = "https://gitlab.com/nomadic-labs/ocaml-uecc";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
