{stdenv, fetchurl, ocaml, fd-send-recv, findlib, uuidm, sexplib, backtrace}:

stdenv.mkDerivation {
  name = "ocaml-stdext-0.13.0";
  version = "0.13.0";

  src = fetchurl {
    url = "https://github.com/xapi-project/stdext/archive/v0.13.0/ocaml-stdext-0.13.0.tar.gz";
    sha256 = "15ahh6bs2g10bhqxckxzv43mf9aw0wl04w8156dskynjc9f461if";
  };

  buildInputs = [ ocaml fd-send-recv findlib uuidm ];
  propagatedBuildInputs = [ sexplib fd-send-recv backtrace ];

  buildPhase = ''
    make
    '';

  createFindlibDestdir = true;

  installPhase = ''
    mkdir -p $OCAMLFIND_DESTDIR/stublibs
    make install DESTDIR=$out
    '';

  meta = {
    homepage = https://github.com/xapi-project/stdext;
    description = "Deprecated misc library functions for OCaml";
    license = stdenv.lib.licenses.lgpl2;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
