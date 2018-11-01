{ stdenv, fetchFromGitHub, ocaml, findlib, dune, alcotest, result
, bigstringaf
}:

if !stdenv.lib.versionAtLeast ocaml.version "4.03"
then throw "angstrom is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  version = "0.10.0";
  name = "ocaml${ocaml.version}-angstrom-${version}";

  src = fetchFromGitHub {
    owner  = "inhabitedtype";
    repo   = "angstrom";
    rev    = "${version}";
    sha256 = "0lh6024yf9ds0nh9i93r9m6p5psi8nvrqxl5x7jwl13zb0r9xfpw";
  };

  buildInputs = [ ocaml findlib dune alcotest ];
  propagatedBuildInputs = [ bigstringaf result ];

  buildPhase = "dune build -p angstrom";

  doCheck = true;
  checkPhase = "dune runtest -p angstrom";

  inherit (dune) installPhase;

  meta = {
    homepage = https://github.com/inhabitedtype/angstrom;
    description = "OCaml parser combinators built for speed and memory efficiency";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ sternenseemann ];
    inherit (ocaml.meta) platforms;
  };
}
