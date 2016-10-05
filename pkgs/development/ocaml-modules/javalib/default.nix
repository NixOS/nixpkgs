{stdenv, fetchurl, which, ocaml, findlib, camlzip, extlib, camlp4}:

let
  pname = "javalib";
  webpage = "http://sawja.inria.fr/";
in
stdenv.mkDerivation rec {
  name = "ocaml-${pname}-${version}";
  version = "2.3";

  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/33090/${pname}-${version}.tar.bz2";
    sha256 = "1i8djcanzm250mwilm3jfy37cz0k0x7jbnrz8a5vvdi91kyzh52j";
  };

  buildInputs = [ which ocaml findlib camlp4 ];

  patches = [ ./configure.sh.patch ./Makefile.config.example.patch ];

  createFindlibDestdir = true;

  preConfigure = "patchShebangs ./configure.sh";

  configureScript = "./configure.sh";
  dontAddPrefix = "true";

  preBuild = ''
    make ptrees;
    make installptrees;
    export OCAMLPATH=$out/lib/ocaml/${ocaml.version}/site-lib/:$OCAMLPATH;
  '';

  propagatedBuildInputs = [ camlzip extlib ];

  meta = with stdenv.lib; {
    description = "A library that parses Java .class files into OCaml data structures";
    homepage = "${webpage}";
    license = licenses.lgpl3;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
