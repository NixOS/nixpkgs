{ lib
, stdenv
, fetchFromGitHub
, which
, ocaml
, findlib
, camlzip
, extlib
}:

lib.throwIfNot (lib.versionAtLeast ocaml.version "4.08")
  "javalib is not available for OCaml ${ocaml.version}"

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-javalib";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "javalib-team";
    repo = "javalib";
    rev = version;
    hash = "sha256-XaI7GTU/O5UEWuYX4yqaIRmEoH7FuvCg/+gtKbE/P1s=";
  };

  nativeBuildInputs = [ which ocaml findlib ];

  strictDeps = true;

  patches = [ ./configure.sh.patch ./Makefile.config.example.patch ];

  createFindlibDestdir = true;

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
