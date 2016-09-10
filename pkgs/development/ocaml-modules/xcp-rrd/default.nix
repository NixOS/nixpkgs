{stdenv, fetchurl, ocaml, camlp4, findlib, obuild, rpc, stdext, uuidm}:

stdenv.mkDerivation {
  name = "ocaml-xcp-rrd-0.9.0";
  version = "0.9.0";

  src = fetchurl {
    url = "https://github.com/xapi-project/xcp-rrd/archive/xcp-rrd-0.9.0/xcp-rrd-0.9.0.tar.gz";
    sha256 = "020sjh1z6pljywkbxxpiw7sd31ply3mjs7sx65p31g8wcblvw87q";
  };

  buildInputs = [ ocaml camlp4 findlib obuild ];

  propagatedBuildInputs = [ rpc stdext uuidm ];

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
    make install
    '';

  meta = {
    homepage = https://github.com/xapi-project/xcp-rrd;
    description = "Round-Robin Datasources in OCaml";
    license = stdenv.lib.licenses.lgpl2;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
