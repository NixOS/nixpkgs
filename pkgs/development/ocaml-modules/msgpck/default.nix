{ lib
, fetchFromGitHub
, buildDunePackage
, ocplib-endian
, alcotest
}:

buildDunePackage rec {
  pname = "msgpck";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "vbmithr";
    repo = "ocaml-msgpck";
    rev = "${version}";
    hash = "sha256-gBHIiicmk/5KBkKzRKyV0ymEH8dGCZG8vfE0mtpcDCM=";
  };

  propagatedBuildInputs = [ ocplib-endian ];

  checkInputs = [ alcotest ];

  doCheck = true;

  meta = {
    description = "Fast MessagePack (http://msgpack.org) library";
    license = lib.licenses.isc;
    homepage = "https://github.com/vbmithr/ocaml-msgpck";
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
