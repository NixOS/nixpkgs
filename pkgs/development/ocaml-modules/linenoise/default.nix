{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  result,
}:

buildDunePackage (finalAttrs: {
  pname = "linenoise";
  version = "1.5.1";

  minimalOCamlVersion = "4.06";

  src = fetchFromGitHub {
    owner = "fxfactorial";
    repo = "ocaml-linenoise";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-yWBWMbk1anXaF4hIakTOcRZFCYmxI0xG3bHFFOAyEDA=";
  };

  propagatedBuildInputs = [ result ];

  meta = {
    description = "OCaml bindings to linenoise";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
    inherit ((finalAttrs.src.meta)) homepage;
  };
})
