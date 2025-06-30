{
  lib,
  buildDunePackage,
  decoders,
  cbor,
  containers,
  ounit2,
}:

buildDunePackage rec {
  pname = "decoders-cbor";

  # sub-package built separately from the same source
  inherit (decoders) src version;

  minimalOCamlVersion = "4.03.0";

  propagatedBuildInputs = [
    decoders
    cbor
  ];

  doCheck = true;
  checkInputs = [
    containers
    ounit2
  ];

  meta = {
    description = "CBOR backend for decoders";
    homepage = "https://github.com/mattjbray/ocaml-decoders";
    changelog = "https://github.com/mattjbray/ocaml-decoders/blob/${version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ infinidoge ];
  };
}
