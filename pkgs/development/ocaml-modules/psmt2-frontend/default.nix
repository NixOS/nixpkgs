{ stdenv, fetchFromGitHub, autoreconfHook, ocaml, findlib, menhir }:

if !stdenv.lib.versionAtLeast ocaml.version "4.03"
then throw "psmt2-frontend is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  version = "0.2";
  name = "ocaml${ocaml.version}-psmt2-frontend-${version}";

  src = fetchFromGitHub {
    owner = "Coquera";
    repo = "psmt2-frontend";
    rev = version;
    sha256 = "097zmbrx4gp2gnrxdmsm9lkkp5450gwi0blpxqy3833m6k5brx3n";
  };

  prefixKey = "-prefix ";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ocaml findlib menhir ];

  createFindlibDestdir = true;

  installFlags = "LIBDIR=$(OCAMLFIND_DESTDIR)";

  meta = {
    description = "A simple parser and type-checker for polomorphic extension of the SMT-LIB 2 language";
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
  };

}
