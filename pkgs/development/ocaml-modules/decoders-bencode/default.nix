{
  lib,
  buildDunePackage,
  decoders,
  bencode,
  containers,
  ounit2,
}:

buildDunePackage rec {
  pname = "decoders-bencode";

  # sub-package built separately from the same source
  inherit (decoders) src version;

  minimalOCamlVersion = "4.03.0";

  propagatedBuildInputs = [
    decoders
    bencode
  ];

  doCheck = true;
  checkInputs = [
    containers
    ounit2
  ];

  meta = {
    description = "Bencode backend for decoders";
    homepage = "https://github.com/mattjbray/ocaml-decoders";
    changelog = "https://github.com/mattjbray/ocaml-decoders/blob/${version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ infinidoge ];
  };
}
