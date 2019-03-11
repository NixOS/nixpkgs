{ stdenv, fetchurl, ocaml, findlib, dune, alcotest, cmdliner, fmt, optint, rresult }:

if !stdenv.lib.versionAtLeast ocaml.version "4.03"
then throw "checkseum is not available for OCaml ${ocaml.version}"
else

# The C implementation is not portable: x86 only
let hasC = stdenv.isi686 || stdenv.isx86_64; in

stdenv.mkDerivation rec {
  version = "0.0.3";
  name = "ocaml${ocaml.version}-checkseum-${version}";
  src = fetchurl {
    url = "https://github.com/mirage/checkseum/releases/download/v0.0.3/checkseum-v0.0.3.tbz";
    sha256 = "12j45zsvil1ynwx1x8fbddhqacc8r1zf7f6h576y3f3yvbg7l1fm";
  };

  postPatch = stdenv.lib.optionalString (!hasC) ''
    rm -r bin src-c
  '';

  buildInputs = [ ocaml findlib dune alcotest cmdliner fmt rresult ];
  propagatedBuildInputs = [ optint ];

  buildPhase = "dune build";

  doCheck = hasC;
  checkPhase = "dune runtest";

  inherit (dune) installPhase;

  meta = {
    homepage = "https://github.com/mirage/checkseum";
    description = "ADLER-32 and CRC32C Cyclic Redundancy Check";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
