{
  lib,
  stdenv,
  fetchurl,
  perl,
  ocaml,
  findlib,
  ocamlbuild,
}:

stdenv.mkDerivation rec {
  pname = "ocaml-cil";
  version = "1.7.3";

  src = fetchurl {
    url = "mirror://sourceforge/cil/cil-${version}.tar.gz";
    hash = "sha256-abfykNKxXdROK4N9PeCSIkW+hB95q1an6bqCBVRL4xQ=";
  };

  nativeBuildInputs = [
    perl
    ocaml
    findlib
    ocamlbuild
  ];

  strictDeps = true;

  createFindlibDestdir = true;

  preConfigure = ''
    substituteInPlace Makefile.in --replace 'MACHDEPCC=gcc' 'MACHDEPCC=$(CC)'
    export FORCE_PERL_PREFIX=1
  '';
  prefixKey = "-prefix=";

  meta = {
    homepage = "https://sourceforge.net/projects/cil/";
    description = "Front-end for the C programming language that facilitates program analysis and transformation";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
    broken = lib.versionAtLeast ocaml.version "4.06";
    platforms = ocaml.meta.platforms or [ ];
  };
}
