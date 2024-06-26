{ lib
, buildDunePackage
, fetchFromGitHub
, base_quickcheck ? null
, capnproto
, ocplib-endian
, ounit2
, res
, result
, stdint
, stdio
}:

buildDunePackage rec {
  pname = "capnp";
  version = "3.6.0";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "capnproto";
    repo = "capnp-ocaml";
    rev = "v${version}";
    hash = "sha256-G4B1llsHnGcuGIarDB248QMaRBvS47IEQB5B93wY7nA=";
  };

  nativeBuildInputs = [
    capnproto
  ];

  buildInputs = [
    stdio
  ];

  propagatedBuildInputs = [
    ocplib-endian
    res
    result
    stdint
  ];

  checkInputs = [
    base_quickcheck
    ounit2
  ];

  doCheck = true;

  meta = {
    description = "OCaml code generation plugin for the Cap'n Proto serialization framework";
    homepage = "https://github.com/capnproto/capnp-ocaml";
    changelog = "https://github.com/capnproto/capnp-ocaml/blob/${version}/CHANGES.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ sixstring982 ];
  };
}
