{stdenv, fetchurl, ocaml, camlp4, findlib}:

stdenv.mkDerivation {
  name = "ocaml-pa-pipebang-110.01.00";
  version = "110.01.00";

  src = fetchurl {
    url = "https://ocaml.janestreet.com/ocaml-core/110.01.00/individual/pipebang-110.01.00.tar.gz";
    sha256 = "15lh68w1vvvng9yk82n89xrdx4cd1h3bx5jifw5dyp610yb8v1d8";
  };

  buildInputs = [ ocaml camlp4 findlib  ];

  configurePhase = ''
    ocaml setup.ml -configure --prefix $out \
          --destdir $out
    '';

  buildPhase = ''
    ocaml setup.ml -build
    '';

  createFindlibDestdir = true;

  installPhase = ''
    export DESTDIR=$out
    mkdir -p $OCAMLFIND_DESTDIR/stublibs
    ocaml setup.ml -install
    '';

  meta = {
    homepage = https://github.com/janestreet/pipebang;
    description = "Syntax extension to transform x |! f into f x";
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
