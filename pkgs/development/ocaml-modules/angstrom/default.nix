{ stdenv, fetchFromGitHub, ocaml, findlib, jbuilder, alcotest, result }:

if !stdenv.lib.versionAtLeast ocaml.version "4.03"
then throw "angstrom is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  version = "0.8.1";
  name = "ocaml${ocaml.version}-angstrom-${version}";

  src = fetchFromGitHub {
    owner  = "inhabitedtype";
    repo   = "angstrom";
    rev    = "${version}";
    sha256 = "067r3vy5lac1bfx947gy722amna3dbcak54nlh24vx87pmcq31qc";
  };

  buildInputs = [ ocaml findlib jbuilder alcotest ];
  propagatedBuildInputs = [ result ];

  buildPhase = "jbuilder build -p angstrom";

  doCheck = true;
  checkPhase = "jbuilder runtest -p angstrom";

  inherit (jbuilder) installPhase;

  meta = {
    homepage = https://github.com/inhabitedtype/angstrom;
    description = "OCaml parser combinators built for speed and memory efficiency";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ sternenseemann ];
    inherit (ocaml.meta) platforms;
  };
}
