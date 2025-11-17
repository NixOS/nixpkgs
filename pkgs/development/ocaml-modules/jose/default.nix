{
  lib,
  buildDunePackage,
  fetchurl,
  containers,
  junit_alcotest,
  astring,
  base64,
  x509,
  yojson,
  zarith,
}:

buildDunePackage rec {
  pname = "jose";
  version = "0.10.0";

  src = fetchurl {
    url = "https://github.com/ulrikstrid/ocaml-jose/releases/download/v${version}/${pname}-${version}.tbz";
    hash = "sha256-F6Odq5JXTkAxdqV3HQusoF+9rvt4BZytslKnsIjJLI8=";
  };

  propagatedBuildInputs = [
    astring
    base64
    x509
    yojson
    zarith
  ];

  doCheck = true;
  checkInputs = [
    containers
    junit_alcotest
  ];

  meta = {
    description = "JOSE specification implementation in OCaml";
    homepage = "https://github.com/ulrikstrid/ocaml-jose";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ulrikstrid
      toastal
      marijanp
    ];
  };
}
