{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  ocaml,
  mdx,
  gitUpdater,
}:

buildDunePackage rec {
  pname = "printbox";
  version = "0.11";

  useDune2 = true;

  minimalOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-f5iTesEakULlLdDGtX+5i3vesUIbFLjcV3kJ7ZPia0Y=";
  };

  nativeCheckInputs = [ mdx.bin ];

  # mdx is not available for OCaml < 4.08
  doCheck = lib.versionAtLeast ocaml.version "4.08";

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    homepage = "https://github.com/c-cube/printbox/";
    description = "Allows to print nested boxes, lists, arrays, tables in several formats";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.romildo ];
  };
}
