{stdenv, fetchurl, makeWrapper, ocaml, camlp4, cmdliner, cstruct, findlib, lwt}:

let
  ocamlVersion = (builtins.parseDrvName (ocaml.name)).version;
in

stdenv.mkDerivation {
  name = "ocaml-nbd-1.0.2";
  version = "1.0.2";

  src = fetchurl {
    url = "https://github.com/xapi-project/nbd/archive/v1.0.2/nbd-1.0.2.tar.gz";
    sha256 = "0l2w3lkyfm708hr0ns7qvwq3f54xp7s647zg6yznpx6smgs9ivs8";
  };

  buildInputs = [ makeWrapper ocaml camlp4 cmdliner cstruct findlib lwt ];

  configurePhase = ''
    export CAML_LD_LIBRARY_PATH=`ocamlfind query cstruct`/../stublibs
    ./configure --prefix $out
    '';

  buildPhase = ''
    make
    '';

  createFindlibDestdir = true;

  installPhase = ''
    make install
    wrapProgram $out/bin/nbd-tool \
        --prefix CAML_LD_LIBRARY_PATH ":" "${ocaml_cstruct}/lib/ocaml/${ocamlVersion}/site-lib/stublibs" \
        --prefix CAML_LD_LIBRARY_PATH ":" "${ocaml_lwt}/lib/ocaml/${ocamlVersion}/site-lib/lwt"
    '';

  meta = {
    homepage = https://github.com/xapi-project/nbd;
    description = "Pure OCaml implementation of the Network Block Device protocol";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
