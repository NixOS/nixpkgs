{ stdenv, fetchFromGitHub, ocaml, findlib, dune, alcotest }:

if !stdenv.lib.versionAtLeast ocaml.version "4.03"
then throw "bigstringaf is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  version = "0.3.0";
  name = "ocaml${ocaml.version}-bigstringaf-${version}";

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = "bigstringaf";
    rev = version;
    sha256 = "1yx6hv8rk0ldz1h6kk00rwg8abpfc376z00aifl9f5rn7xavpscs";
  };

  buildInputs = [ ocaml findlib dune alcotest ];

  doCheck = true;
  checkPhase = "dune runtest";

  inherit (dune) installPhase;

  meta = {
    description = "Bigstring intrinsics and fast blits based on memcpy/memmove";
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
  };
}
