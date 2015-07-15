{stdenv, fetchurl, ocaml, findlib}:

stdenv.mkDerivation {
  name = "ocaml-sha-1.9";
  version = "1.9";

  src = fetchurl {
    url = "https://github.com/vincenthz/ocaml-sha/archive/ocaml-sha-v1.9/ocaml-sha-1.9.tar.gz";
    sha256 = "1l48l310cl17jz8lxv787plbbhsahbhvh6q6h2hnrif2f68dv8fa";
  };

  buildInputs = [ ocaml findlib ];

  buildPhase = ''
    make
    '';

  createFindlibDestdir = true;

  installPhase = ''
    export OCAMLFIND_LDCONF=$OCAMLFIND_DESTDIR/ld.conf
    make install
    '';

  meta = {
    homepage = https://github.com/vincenthz/ocaml-sha;
    description = "OCaml SHA";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
