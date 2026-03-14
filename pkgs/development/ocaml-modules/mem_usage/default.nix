{
  lib,
  fetchFromGitHub,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "mem_usage";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-mem_usage";
    rev = "v${version}";
    hash = "sha256-0XFltWPTOIs1h3CIit4NPkAb+dS74GubZB0shqbuvTs=";
  };

  minimalOCamlVersion = "4.07";

  doCheck = true;

  meta = {
    license = lib.licenses.mit;
    homepage = "https://www.liquidsoap.info/ocaml-mem_usage/";
    description = "Cross-platform memory usage information";
    maintainers = [ lib.maintainers.vbgl ];
  };
}
