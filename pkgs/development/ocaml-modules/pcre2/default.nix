{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  dune-configurator,
  pcre2,
  version ? "8.0.4",
}:

buildDunePackage {
  pname = "pcre2";
  inherit version;

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "camlp5";
    repo = "pcre2-ocaml";
    tag = version;
    hash = "sha256-UCz8l7kx8d6wlRzLwIx4+LmkG7mwzxy9Ca2DwMT2u+E=";
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
