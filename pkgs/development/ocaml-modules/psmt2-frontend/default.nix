{ stdenv, fetchFromGitHub, autoreconfHook, ocaml, findlib, menhir }:

if !stdenv.lib.versionAtLeast ocaml.version "4.03"
then throw "psmt2-frontend is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  version = "0.1";
  name = "ocaml${ocaml.version}-psmt2-frontend-${version}";

  src = fetchFromGitHub {
    owner = "Coquera";
    repo = "psmt2-frontend";
    rev = version;
    sha256 = "0k7jlsbkdyg7hafmvynp0ik8xk7mfr00wz27vxn4ncnmp20yz4vn";
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
