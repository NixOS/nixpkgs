{stdenv, fetchurl, ocaml, cmdliner, findlib, obuild, ounit, yojson}:

stdenv.mkDerivation {
  name = "ocaml-qmp-0.9.2";
  version = "0.9.2";

  src = fetchurl {
    url = "https://github.com/xapi-project/ocaml-qmp/archive/0.9.2/ocaml-qmp-0.9.2.tar.gz";
    sha256 = "1ip107z7jn62csjrax13naz86lgd5jrnpic80rq2yrwd80yr07i8";
  };

  buildInputs = [ ocaml cmdliner findlib obuild ounit ];
  propagatedBuildInputs = [ yojson ];


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
    make install DESTDIR=$OCAMLFIND_DESTDIR
    '';

  meta = {
    homepage = https://github.com/xapi-project/ocaml-qmp;
    description = "Pure OCaml implementation of the Qemu Message Protocol (QMP)";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
