{
  lib,
  fetchFromGitHub,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "getopt";
  version = "20230213";

  minimalOCamlVersion = "4.07";

  src = fetchFromGitHub {
    owner = "scemama";
    repo = "ocaml-getopt";
    rev = version;
    hash = "sha256-oYDm945LgjIW+8x7UrO4FlbHywnu8480aiEVvnjBxc8=";
  };

  doCheck = true;

  meta = {
    homepage = "https://github.com/scemama/ocaml-getopt";
    description = "Parsing of command line arguments (similar to GNU GetOpt) for OCaml";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
