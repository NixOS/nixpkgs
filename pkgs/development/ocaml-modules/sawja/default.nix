{ stdenv, fetchFromGitHub, which, perl, ocaml, findlib, javalib }:

let
  pname = "sawja";
  version = "1.5.8";
  webpage = "http://sawja.inria.fr/";
in

if !stdenv.lib.versionAtLeast ocaml.version "4.07"
then throw "${pname} is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation {

  name = "ocaml${ocaml.version}-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "javalib-team";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rawr0jav33rvagm8sxc0arc7ya1fd9w5nng3lhfk8p02f9z8wrp";
  };

  buildInputs = [ which perl ocaml findlib ];

  patches = [ ./configure.sh.patch ./Makefile.config.example.patch ];

  createFindlibDestdir = true;

  preConfigure = "patchShebangs ./configure.sh";

  configureScript = "./configure.sh";
  dontAddPrefix = "true";

  propagatedBuildInputs = [ javalib ];

  meta = with stdenv.lib; {
    description = "A library written in OCaml, relying on Javalib to provide a high level representation of Java bytecode programs";
    homepage = webpage;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
