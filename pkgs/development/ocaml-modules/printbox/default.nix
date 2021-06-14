{ lib, fetchFromGitHub, buildDunePackage, ocaml, uucp, uutf, mdx }:

buildDunePackage rec {
  pname = "printbox";
  version = "0.5";

  useDune2 = true;

  minimumOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = pname;
    rev = version;
    sha256 = "099yxpp7d9bms6dwzp9im7dv1qb801hg5rx6awpx3rpfl4cvqfn2";
  };

  checkInputs = [ uucp uutf mdx.bin ];

  # mdx is not available for OCaml < 4.07
  doCheck = lib.versionAtLeast ocaml.version "4.07";

  meta = {
    homepage = "https://github.com/c-cube/printbox/";
    description = "Allows to print nested boxes, lists, arrays, tables in several formats";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.romildo ];
  };
}
