{stdenv, fetchurl, chrpath, ocaml, camlp4, findlib}:

stdenv.mkDerivation {
  name = "ocaml-inotify-2.0";
  version = "2.0";

  src = fetchurl {
    url = "https://github.com/whitequark/ocaml-inotify/archive/2.0.tar.gz";
    sha256 = "1lgs2yvsi4sb69h8bbqpfc67gh84dgs6hbdwk7rmhxwmw5mxa1ni";
  };

  buildInputs = [ chrpath ocaml camlp4 findlib ];

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

    strip $OCAMLFIND_DESTDIR/stublibs/dll*.so
    chrpath --delete $OCAMLFIND_DESTDIR/stublibs/dll*.so
    '';

  meta = {
    homepage = https://github.com/whitequark/ocaml-inotify;
    description = "Inotify bindings for OCaml.";
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
