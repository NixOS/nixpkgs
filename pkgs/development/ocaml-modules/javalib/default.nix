{stdenv, fetchurl, which, ocaml, findlib, camlzip, extlib, camlp4}:

if !stdenv.lib.versionAtLeast ocaml.version "4"
then throw "javalib not supported for ocaml ${ocaml.version}"
else

let
  pname = "javalib";
  webpage = "http://sawja.inria.fr/";
in
stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-${pname}-${version}";
  version = "2.3.3";

  src = fetchurl {
    url = https://gforge.inria.fr/frs/download.php/file/36307/javalib-2.3.3.tar.bz2;
    sha256 = "0427n3vfb2h51gy2p4878gdwlp0mb03asn3g9kp9v4wfxmksjj11";
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
