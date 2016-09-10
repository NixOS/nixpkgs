{stdenv, fetchurl, libffi, libnl, ocaml, ctypes, findlib, obuild, camlp4}:

stdenv.mkDerivation {
  name = "ocaml-netlink-0.2.0";
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/xapi-project/ocaml-netlink/archive/v0.2.0.tar.gz";
    sha256 = "092b3dhd27hs4gfpfpq8f9r487ri2d8p5gmrzprszc191gzs0a47";
  };

  patches = [ ./notest.patch ];

  buildInputs = [ libffi libnl ocaml findlib obuild camlp4 ];

  propagatedBuildInputs = [ ctypes ];

  buildPhase = ''
    cat << EOF >> findlib.conf
    destdir="$OCAMLFIND_DESTDIR"
    path="$OCAMLPATH"
    ldconf="ignore"
    ocamlc="ocamlc.opt"
    ocamlopt="ocamlopt.opt"
    ocamldep="ocamldep.opt"
    ocamldoc="ocamldoc.opt"
    EOF
    export OCAMLFIND_CONF=`pwd`/findlib.conf

    make
    '';

  createFindlibDestdir = true;

  installPhase = ''
    mkdir -p $OCAMLFIND_DESTDIR/stublibs
    export OCAMLFIND_LDCONF=ignore
    make install DESTDIR=$OCAMLFIND_DESTDIR
    '';

  meta = {
    homepage = https://github.com/xapi-project/ocaml-netlink;
    description = "OCaml bindings to libnl";
    license = stdenv.lib.licenses.lgpl2;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
