{
  lib,
  buildDunePackage,
  decoders,
  ezxmlm,
  containers,
}:

buildDunePackage rec {
  pname = "decoders-ezxmlm";

  # sub-package built separately from the same source
  inherit (decoders) src version;

  minimalOCamlVersion = "4.03.0";

  propagatedBuildInputs = [
    decoders
    ezxmlm
  ];

  doCheck = true;
  checkInputs = [
    containers
  ];

  meta = {
    description = "Ezxmlm backend for decoders";
    homepage = "https://github.com/mattjbray/ocaml-decoders";
    changelog = "https://github.com/mattjbray/ocaml-decoders/blob/${version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ infinidoge ];
  };
}
