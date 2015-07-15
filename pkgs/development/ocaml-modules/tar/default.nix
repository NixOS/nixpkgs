{stdenv, fetchurl, ocaml, camlp4, cstruct, findlib, lwt, ounit, re, libev}:

stdenv.mkDerivation {
  name = "ocaml-tar-0.2.1";
  version = "0.2.1";

  src = fetchurl {
    url = "https://github.com/djs55/ocaml-tar/archive/0.2.1/ocaml-tar-0.2.1.tar.gz";
    sha256 = "08f1bncfy84blb2w1zfz74b14aq686j6x3xjblznghnc0qiggvjd";
  };

  buildInputs = [ ocaml camlp4 cstruct findlib lwt ounit re libev ];

  configurePhase = ''
    ocaml setup.ml -configure --destdir $out
    '';

  buildPhase = ''
    ocaml setup.ml -build
    '';

  createFindlibDestdir = true;

  installPhase = ''
    export OCAMLFIND_LDCONF=$OCAMLFIND_DESTDIR/ld.conf
    ocaml setup.ml -install
    '';

  meta = {
    homepage = https://github.com/djs55/ocaml-tar;
    description = "OCaml parser and printer for tar-format data";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
