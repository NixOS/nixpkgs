{
  lib,
  stdenv,
  fetchurl,
  perl,
  ocaml,
  findlib,
  ocamlbuild,
}:

if lib.versionAtLeast ocaml.version "4.06" then
  throw "cil is not available for OCaml ${ocaml.version}"
else

  stdenv.mkDerivation rec {
    pname = "ocaml-cil";
    version = "1.7.3";

    src = fetchurl {
      url = "mirror://sourceforge/cil/cil-${version}.tar.gz";
      sha256 = "05739da0b0msx6kmdavr3y2bwi92jbh3szc35d7d8pdisa8g5dv9";
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

    meta = with lib; {
      homepage = "https://sourceforge.net/projects/cil/";
      description = "Front-end for the C programming language that facilitates program analysis and transformation";
      license = licenses.bsd3;
      maintainers = [ maintainers.vbgl ];
      platforms = ocaml.meta.platforms or [ ];
    };
  }
