{ stdenv, fetchzip, which, ocaml, findlib
, camlzip, extlib
}:

if !stdenv.lib.versionAtLeast ocaml.version "4.04"
then throw "javalib is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-javalib-${version}";
  version = "3.2.1";

  src = fetchzip {
    url = "https://github.com/javalib-team/javalib/archive/v${version}.tar.gz";
    sha256 = "1fkdaiiza145yv0r1cm0n2hsrr0rbn6b27vs66njgv405zwn3vbn";
  };

  buildInputs = [ which ocaml findlib ];

  patches = [ ./configure.sh.patch ./Makefile.config.example.patch ];

  createFindlibDestdir = true;

  preConfigure = "patchShebangs ./configure.sh";

  configureScript = "./configure.sh";
  dontAddPrefix = "true";

  propagatedBuildInputs = [ camlzip extlib ];

  meta = with stdenv.lib; {
    description = "A library that parses Java .class files into OCaml data structures";
    homepage = https://javalib-team.github.io/javalib/;
    license = licenses.lgpl3;
    maintainers = [ maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
