{
  lib,
  buildDunePackage,
  fetchurl,
  zarith,
}:

let
  version = "0.8.2";
in

buildDunePackage {
  pname = "bitwuzla-cxx";
  inherit version;

  minimalOCamlVersion = "4.12";

  src = fetchurl {
    url = "https://github.com/bitwuzla/ocaml-bitwuzla/releases/download/${version}/bitwuzla-cxx-${version}.tbz";
    hash = "sha256-cfYQBY/Nwf9XyK5clRPxf6ejqNRn/GugVFMKBm3BEME=";
  };

  propagatedBuildInputs = [ zarith ];

  meta = {
    description = "OCaml binding for the SMT solver Bitwuzla C++ API";
    homepage = "https://bitwuzla.github.io/";
    changelog = "https://raw.githubusercontent.com/bitwuzla/ocaml-bitwuzla/refs/tags/${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
