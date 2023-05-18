{ lib, fetchFromGitHub, buildDunePackage, result }:

buildDunePackage rec {
  pname = "linenoise";
  version = "1.4.0";

  minimalOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "fxfactorial";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    sha256 = "sha256-bIpZ9TO4/j24nQw5nsW7fUF7af5lhd/EmwhQRd0NYb4=";
  };

  propagatedBuildInputs = [ result ];

  meta = {
    description = "OCaml bindings to linenoise";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
