{ lib, fetchFromGitHub, buildDunePackage, ocaml, mdx }:

buildDunePackage rec {
  pname = "printbox";
  version = "0.6";

  useDune2 = true;

  minimalOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256:0vqp8j1vp8h8par699nnh31hnikzh6pqn07lqyxw65axqy3sc9dp";
  };

  checkInputs = [ mdx.bin ];

  # mdx is not available for OCaml < 4.07
  doCheck = lib.versionAtLeast ocaml.version "4.07";

  meta = {
    homepage = "https://github.com/c-cube/printbox/";
    description = "Allows to print nested boxes, lists, arrays, tables in several formats";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.romildo ];
  };
}
