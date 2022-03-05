{ lib, stdenv, fetchFromGitHub, which, ocaml, findlib, javalib }:

let
  pname = "sawja";
  version = "1.5.10";
  webpage = "http://sawja.inria.fr/";
in

if !lib.versionAtLeast ocaml.version "4.07"
then throw "${pname} is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation {

  pname = "ocaml${ocaml.version}-${pname}";

  inherit version;

  src = fetchFromGitHub {
    owner = "javalib-team";
    repo = pname;
    rev = version;
    sha256 = "sha256:0k51rscs9mdgpg3qn4cahql5ncdvlb207m015hr8v6r1vfgn0ddq";
  };

  nativeBuildInputs = [ which ocaml findlib ];

  strictDeps = true;

  patches = [ ./configure.sh.patch ./Makefile.config.example.patch ];

  createFindlibDestdir = true;

  preConfigure = "patchShebangs ./configure.sh";

  configureScript = "./configure.sh";
  dontAddPrefix = "true";
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [];

  propagatedBuildInputs = [ javalib ];

  meta = with lib; {
    description = "A library written in OCaml, relying on Javalib to provide a high level representation of Java bytecode programs";
    homepage = webpage;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
