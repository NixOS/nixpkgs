{
  lib,
  buildDunePackage,
  decoders,
  jsonaf,
  containers,
  ounit2,
}:

buildDunePackage rec {
  pname = "decoders-jsonaf";

  # sub-package built separately from the same source
  inherit (decoders) src version;

  minimalOCamlVersion = "4.10.0";

  propagatedBuildInputs = [
    decoders
    jsonaf
  ];

  doCheck = true;
  checkInputs = [
    containers
    ounit2
  ];

  meta = {
    description = "Jsonaf backend for decoders";
    homepage = "https://github.com/mattjbray/ocaml-decoders";
    changelog = "https://github.com/mattjbray/ocaml-decoders/blob/${version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ infinidoge ];
  };
}
