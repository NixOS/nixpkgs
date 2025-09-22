{
  lib,
  buildDunePackage,
  decoders,
  msgpck,
  containers,
  ounit2,
}:

buildDunePackage rec {
  pname = "decoders-msgpck";

  # sub-package built separately from the same source
  inherit (decoders) src version;

  minimalOCamlVersion = "4.03.0";

  propagatedBuildInputs = [
    decoders
    msgpck
  ];

  doCheck = true;
  checkInputs = [
    containers
    ounit2
  ];

  meta = {
    description = "Msgpck backend for decoders";
    homepage = "https://github.com/mattjbray/ocaml-decoders";
    changelog = "https://github.com/mattjbray/ocaml-decoders/blob/${version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ infinidoge ];
  };
}
