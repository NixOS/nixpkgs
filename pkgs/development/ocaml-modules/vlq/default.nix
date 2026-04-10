{
  lib,
  buildDunePackage,
  fetchurl,
  ocaml,
  dune-configurator,
}:

buildDunePackage rec {
  pname = "vlq";
  version = "0.2.1";

  src = fetchurl {
    url = "https://github.com/flowtype/ocaml-vlq/releases/download/v${version}/vlq-v${version}.tbz";
    sha256 = "02wr9ph4q0nxmqgbc67ydf165hmrdv9b655krm2glc3ahb6larxi";
  };

  buildInputs = [ dune-configurator ];

  meta = {
    description = "Encoding variable-length quantities, in particular base64";
    license = lib.licenses.mit;
    homepage = "https://github.com/flowtype/ocaml-vlq";
    maintainers = [ lib.maintainers.nomeata ];
    broken = lib.versionAtLeast ocaml.version "5.0";
  };

}
