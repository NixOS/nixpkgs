{ lib, fetchFromGitHub, buildDunePackage, ocaml, mdx }:

buildDunePackage rec {
  pname = "printbox";
  version = "0.6.1";

  useDune2 = true;

  minimalOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7u2ThRhM3vW4ItcFsK4ycgcaW0JcQOFoZZRq2kqbl+k=";
  };

  checkInputs = [ mdx.bin ];

  # mdx is not available for OCaml < 4.08
  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = {
    homepage = "https://github.com/c-cube/printbox/";
    description = "Allows to print nested boxes, lists, arrays, tables in several formats";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.romildo ];
  };
}
