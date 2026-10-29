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
    hash = "sha256-sWdFzYJqMPpEzbMUs9JuucJigmv+GLYert0CTOBNmQs=";
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
