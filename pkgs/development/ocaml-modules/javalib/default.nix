{ lib
, stdenv
, fetchFromGitHub
, which
, ocaml
, findlib
, camlzip
, extlib
}:

if !lib.versionAtLeast ocaml.version "4.04"
then throw "javalib is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-javalib";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "javalib-team";
    repo = "javalib";
    rev = "v${version}";
    sha256 = "sha256-du1h+S+A7CetMXofsYxdGeSsobCgspDB9oUE9WNUbbo=";
  };

  nativeBuildInputs = [ which ocaml findlib ];

  strictDeps = true;

  patches = [ ./configure.sh.patch ./Makefile.config.example.patch ];

  createFindlibDestdir = true;

  preConfigure = "patchShebangs ./configure.sh";

  configureScript = "./configure.sh";
  dontAddPrefix = "true";
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [ ];

  propagatedBuildInputs = [ camlzip extlib ];

  meta = with lib; {
    description = "A library that parses Java .class files into OCaml data structures";
    homepage = "https://javalib-team.github.io/javalib/";
    license = licenses.lgpl3;
    maintainers = [ maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
