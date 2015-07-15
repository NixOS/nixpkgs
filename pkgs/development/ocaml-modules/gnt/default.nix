{stdenv, fetchurl, ocaml, xen, camlp4, cmdliner, cstruct, findlib, io-page, lwt, libev}:

stdenv.mkDerivation {
  name = "ocaml-gnt-1.0.0";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/xapi-project/ocaml-gnt/archive/v1.0.0/ocaml-gnt-1.0.0.tar.gz";
    sha256 = "1w8b7yv3l70sy7lzmkb1pj7hmh3km5lxsafvadbi00rg2saplsrp";
  };

  buildInputs = [ ocaml xen camlp4 cmdliner cstruct findlib libev ];

  propagatedBuildInputs = [ lwt io-page ];

  buildPhase = ''
    make
    '';

  createFindlibDestdir = true;

  installPhase = ''
    export OCAMLFIND_LDCONF=$OCAMLFIND_DESTDIR/ld.conf
    ocaml setup.ml -install
    '';

  meta = {
    homepage = https://github.com/xapi-project/ocaml-gnt/;
    description = "OCaml bindings for userspace Xen grant table controls";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
