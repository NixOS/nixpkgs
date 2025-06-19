{
  lib,
  buildDunePackage,
  fetchurl,
  zarith,
}:

buildDunePackage rec {
  pname = "bitwuzla-cxx";
  version = "0.8.0";

  minimalOCamlVersion = "4.12";

  src = fetchurl {
    url = "https://github.com/bitwuzla/ocaml-bitwuzla/releases/download/${version}/bitwuzla-cxx-${version}.tbz";
    hash = "sha256-t8Vgbiec5m6CYV8bINJqs6uhx0YAJcRZeaWRGNoD6AQ=";
  };

  propagatedBuildInputs = [ zarith ];

  meta = {
    description = "OCaml binding for the SMT solver Bitwuzla C++ API";
    longDescription = ''
      OCaml binding for the SMT solver Bitwuzla C++ API.

      Bitwuzla is a Satisfiability Modulo Theories (SMT) solver for the theories of fixed-size bit-vectors, arrays and uninterpreted functions and their combinations. Its name is derived from an Austrian dialect expression that can be translated as “someone who tinkers with bits”.
    '';
    homepage = "https://bitwuzla.github.io/";
    changelog = "https://raw.githubusercontent.com/bitwuzla/ocaml-bitwuzla/refs/tags/${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
