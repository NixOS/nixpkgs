{stdenv, fetchurl, ocaml, findlib}:

stdenv.mkDerivation {
  name = "ocaml-fd-send-recv-1.0.1";
  version = "1.0.1";

  src = fetchurl {
    url = "https://github.com/xapi-project/ocaml-fd-send-recv/archive/ocaml-fd-send-recv-1.0.1/ocaml-fd-send-recv-1.0.1.tar.gz";
    sha256 = "14iw9zlz1bd2qvn4wzp54bhhz3gy704h2mwhd39r6921cfdi0kv6";
  };

  buildInputs = [ ocaml findlib ];

  configurePhase = ''
    ocaml setup.ml -configure
    '';

  buildPhase = ''
    ocaml setup.ml -build
    '';

  createFindlibDestdir = true;

  installPhase = ''
    mkdir -p $OCAMLFIND_DESTDIR/stublibs
    export OCAMLFIND_LDCONF=ignore
    make install
    '';

  meta = {
    homepage = https://github.com/xapi-project/ocaml-fd-send-recv;
    description = "Bindings to sendmsg/recvmsg for fd passing under Linux";
    license = stdenv.lib.licenses.lgpl2;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
