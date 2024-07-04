{ lib, stdenv, fetchFromGitHub, which, ocaml, findlib, javalib }:

let
  pname = "sawja";
  version = "1.5.12";
in

lib.throwIfNot (lib.versionAtLeast ocaml.version "4.08")
  "${pname} is not available for OCaml ${ocaml.version}"

stdenv.mkDerivation {

  pname = "ocaml${ocaml.version}-${pname}";

  inherit version;

  src = fetchFromGitHub {
    owner = "javalib-team";
    repo = pname;
    rev = version;
    hash = "sha256-G1W8/G0TEcldnFnH/NAb9a6ZSGGP2fWTM47lI8bBHnw=";
  };

  nativeBuildInputs = [ which ocaml findlib ];

  strictDeps = true;

  patches = [ ./configure.sh.patch ./Makefile.config.example.patch ];

  createFindlibDestdir = true;

  configureScript = "./configure.sh";
  dontAddPrefix = "true";
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [];

  propagatedBuildInputs = [ javalib ];

  meta = with lib; {
    description = "Library written in OCaml, relying on Javalib to provide a high level representation of Java bytecode programs";
    homepage = "http://sawja.inria.fr/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
