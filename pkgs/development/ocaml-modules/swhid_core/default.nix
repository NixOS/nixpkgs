{
  lib,
  fetchFromGitHub,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "swhid_core";
  version = "0.1";

  minimalOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "swhid_core";
    rev = version;
    hash = "sha256-uLnVbptCvmBeNbOjGjyAWAKgzkKLDTYVFY6SNH2zf0A=";
  };

  meta = {
    description = "OCaml library to work with swhids";
    homepage = "https://github.com/ocamlpro/swhid_core";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
