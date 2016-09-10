{stdenv, fetchurl, ocaml, cstruct, findlib, ounit}:

stdenv.mkDerivation {
  name = "ocaml-crc-0.9.1";
  version = "0.9.1";

  src = fetchurl {
    url = "https://github.com/xapi-project/ocaml-crc/archive/0.9.1/ocaml-crc-0.9.1.tar.gz";
    sha256 = "1azw2dqb7rx2p9x8qnxw4vpi1k3j78bpj8k62cblifn0gzpd2yii";
  };

  buildInputs = [ ocaml cstruct findlib ounit ];

  configurePhase = ''
    ocaml setup.ml -configure --prefix $out --destdir $out
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
    homepage = https://github.com/xapi-project/ocaml-crc/;
    description = "CRC implementation for OCaml";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
