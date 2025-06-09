{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  dune-configurator,
  pcre2,
  version ? "8.0.3",
}:

buildDunePackage {
  pname = "pcre2";
  inherit version;

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "camlp5";
    repo = "pcre2-ocaml";
    tag = version;
    hash = "sha256-YqzpK4Syh9pP64+bwdSiphdfJdwsWQSaOrpKsoKSWyU=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ pcre2 ];

  meta = {
    description = "OCaml bindings to PCRE";
    homepage = "https://github.com/camlp5/pcre2-ocaml/";
    changelog = "https://raw.githubusercontent.com/camlp5/pcre2-ocaml/refs/tags/${version}/CHANGES.md";
    license = lib.licenses.lgpl21Only;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
