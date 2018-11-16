{ stdenv, fetchurl, which, ocaml, findlib, camlp4
, camlzip, camomile, extlib
}:

if !stdenv.lib.versionAtLeast ocaml.version "4"
then throw "javalib not supported for ocaml ${ocaml.version}"
else

let
  pname = "javalib";
  webpage = "http://sawja.inria.fr/";
in
stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-${pname}-${version}";
  version = "2.3.5";

  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/file/37655/javalib-2.3.5.tar.bz2";
    sha256 = "1gks12ghcmv9lm8j4diw8bvjqxfl7xwk0sxbi227saxg9irpwwkd";
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

  propagatedBuildInputs = [ camlzip camomile extlib ];

  meta = with stdenv.lib; {
    description = "A library that parses Java .class files into OCaml data structures";
    homepage = "${webpage}";
    license = licenses.lgpl3;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
