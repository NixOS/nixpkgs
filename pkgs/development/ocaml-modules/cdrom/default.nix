{stdenv, fetchurl, ocaml, findlib, obuild}:

stdenv.mkDerivation {
  name = "ocaml-cdrom-0.9.1";
  version = "0.9.1";

  src = fetchurl {
    url = "https://github.com/xapi-project/cdrom/archive/cdrom-0.9.1/cdrom-0.9.1.tar.gz";
    sha256 = "1q0f58xi9v91mqzrgz0g0w1k235s6qjak30cj12688ify3l0wh5x";
  };

  buildInputs = [ ocaml findlib obuild ];

  buildPhase = ''
    make
    '';

  createFindlibDestdir = true;

  installPhase = ''
    mkdir -p $OCAMLFIND_DESTDIR/stublibs
    export OCAMLFIND_LDCONF=ignore
    make install DESTDIR=$OCAMLFIND_DESTDIR
    '';

  meta = {
    homepage = https://github.com/xapi-project/cdrom;
    description = "Query the state of CDROM devices";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
