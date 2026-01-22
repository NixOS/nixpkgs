{
  lib,
  buildDunePackage,
  fetchurl,
  ocplib-endian,
  yojson,
}:

buildDunePackage rec {
  pname = "cbor";
  version = "0.5";

  minimalOCamlVersion = "4.07.0";

  src = fetchurl {
    url = "https://github.com/ygrek/ocaml-cbor/releases/download/${version}/ocaml-cbor-${version}.tar.gz";
    hash = "sha256-4mpm/fv9X5uFRQO8XqBhOpxYwZreEtJ3exIwN6YulKM=";
  };

  propagatedBuildInputs = [
    ocplib-endian
  ];

  doCheck = true;
  checkInputs = [
    yojson
  ];

  meta = {
    description = "CBOR encoder/decoder (RFC 7049) - native OCaml implementation";
    homepage = "https://github.com/ygrek/ocaml-cbor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ infinidoge ];
  };
}
