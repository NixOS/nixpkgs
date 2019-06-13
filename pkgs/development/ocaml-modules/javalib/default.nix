{ stdenv, fetchzip, which, ocaml, findlib, camlp4
, camlzip, camomile, extlib
}:

if !stdenv.lib.versionAtLeast ocaml.version "4"
then throw "javalib not supported for ocaml ${ocaml.version}"
else

let
  pname = "javalib";
in
stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-${pname}-${version}";
  version = "3.0";

  src = fetchzip {
    url = "https://github.com/javalib-team/javalib/archive/v${version}.tar.gz";
    sha256 = "02zgn1z1wj3rbg9xqmbagys91bnsy27iwrngkivzhlykyaw9vf6n";
  };

  buildInputs = [ which ocaml findlib camlp4 ];

  patches = [ ./configure.sh.patch ./Makefile.config.example.patch ];

  createFindlibDestdir = true;

  preConfigure = "patchShebangs ./configure.sh";

  configureScript = "./configure.sh";
  dontAddPrefix = "true";

  propagatedBuildInputs = [ camlzip camomile extlib ];

  meta = with stdenv.lib; {
    description = "A library that parses Java .class files into OCaml data structures";
    homepage = https://javalib-team.github.io/javalib/;
    license = licenses.lgpl3;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
