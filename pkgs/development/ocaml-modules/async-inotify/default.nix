{stdenv, fetchurl, ocaml, async, async-find, camlp4, comparelib, custom-printf, enumerate, findlib, herelib, inotify, sexplib}:

stdenv.mkDerivation {
  name = "ocaml-async-inotify-111.28.00";
  version = "111.28.00";

  src = fetchurl {
    url = "https://ocaml.janestreet.com/core/111.28.00/individual/async_inotify-111.28.00.tar.gz";
    sha256 = "11q6zy5v0lqmz4cprjfm8azxjw4nqxi26jx1aajgazp8dd7ay28v";
  };

  buildInputs = [ ocaml camlp4 comparelib custom-printf enumerate findlib herelib sexplib ];

  propagatedBuildInputs = [ async-find async inotify ];

  configurePhase = ''
    ocaml setup.ml -configure --prefix $out \
          --destdir $out
    '';

  buildPhase = ''
    ocaml setup.ml -build
    '';

  createFindlibDestdir = true;

  installPhase = ''
    export DESTDIR=$out
    mkdir -p $OCAMLFIND_DESTDIR/stublibs
    ocaml setup.ml -install
    '';

  meta = {
    homepage = https://github.com/janestreet/async_inotify;
    description = "Jane Street Capital's asynchronous execution library (core)";
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
