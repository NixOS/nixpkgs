{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  result,
}:

buildDunePackage rec {
  pname = "linenoise";
  version = "1.5.1";

  minimalOCamlVersion = "4.06";

  src = fetchFromGitHub {
    owner = "fxfactorial";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    sha256 = "sha256-yWBWMbk1anXaF4hIakTOcRZFCYmxI0xG3bHFFOAyEDA=";
  };

  propagatedBuildInputs = [ result ];

  meta = with lib; {
    description = "OCaml bindings to linenoise";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
