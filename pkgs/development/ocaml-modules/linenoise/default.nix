{ lib, fetchFromGitHub, buildDunePackage, result }:

buildDunePackage rec {
  pname = "linenoise";
  version = "1.3.0";

  useDune2 = true;

  minimumOCamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "fxfactorial";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    sha256 = "0m9mm1arsawi5w5aqm57z41sy1wfxvhfgbdiw7hzy631i391144g";
  };

  propagatedBuildInputs = [ result ];

  meta = {
    description = "OCaml bindings to linenoise";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
