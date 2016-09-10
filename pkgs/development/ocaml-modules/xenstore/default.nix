{stdenv, fetchurl, ocaml, camlp4, cstruct, findlib, lwt, ounit, libev}:

stdenv.mkDerivation {
  name = "ocaml-xenstore-1.2.4";
  version = "1.2.4";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-xenstore/archive/1.2.4/ocaml-xenstore-1.2.4.tar.gz";
    sha256 = "1acj6k095fkwpv5h8mpfp9g98n361ks2yq60cvblxaqxrb3014sg";
  };

  buildInputs = [ ocaml camlp4 findlib lwt ounit libev ];

  propagatedBuildInputs = [ cstruct ];

  configurePhase = ''
    ocaml setup.ml -configure
    '';

  buildPhase = ''
    make
    '';

  createFindlibDestdir = true;

  installPhase = ''
    make install
    '';

  meta = {
    homepage = https://github.com/mirage/ocaml-xenstore;
    description = "Xenstore protocol implementation in OCaml";
    license = stdenv.lib.licenses.lgpl2;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
