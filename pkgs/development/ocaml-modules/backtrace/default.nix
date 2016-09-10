{stdenv, fetchurl, ocaml, findlib, sexplib}:

stdenv.mkDerivation {
  name = "ocaml-backtrace-0.1";
  version = "0.1";

  src = fetchurl {
    url = "https://github.com/xapi-project/backtrace/archive/v0.1/ocaml-backtrace-0.1.tar.gz";
    sha256 = "0ihcjinxz9imcfpk6xmczwlhp35lav8bcz2c1li4m4n2c0kxrbr0";
  };

  buildInputs = [ ocaml findlib ];
  propagatedBuildInputs = [ sexplib ];

  createFindlibDestdir = true;

  installPhase = ''
    mkdir -p $out/lib/ocaml
    mkdir -p $OCAMLFIND_DESTDIR/stublibs
    ocaml setup.ml -install
    '';

  meta = {
    homepage = https://github.com/xapi-project/backtrace;
    description = "Library for processing backtraces across hosts/processes/languages";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
